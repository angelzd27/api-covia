import { pool_db } from '../connection/connection.js';
import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';
import axios from 'axios';
import { decrypt } from '../utils/encrypt.js';

dotenv.config();

export const allDevices = async (request, response) => {
    const { authorization } = request.headers
    const { id, key } = jwt.verify(authorization, process.env.SECRET_KEY)
    const decryptedKey = decrypt(key);
    let devicesDatabase = []
    let devicesAPI = []
    const queryGetGroups = `
        SELECT groups.id, groups.group
        FROM groups
        JOIN user_group ON groups.id = user_group.group_id
        WHERE groups.status = true AND user_group.user_id = $1
    `

    const { rows } = await pool_db.query(queryGetGroups, [id])
    for (const group of rows) {
        const queryGetDevices = `
            SELECT *
            FROM devices
            JOIN group_device ON devices.id = group_device.device_id
            WHERE devices.status = true AND group_device.group_id = $1
        `

        const resultDevices = (await pool_db.query(queryGetDevices, [group.id])).rows
        devicesDatabase = devicesDatabase.concat(resultDevices)
    }

    const configResponseAPI = {
        method: 'POST',
        url: 'http://74.208.169.184:12056/api/v1/basic/gps/last',
        headers: { 'accept': 'application/json', },
        data: { key: decryptedKey, terid: devicesDatabase.map(device => device.id) }
    }

    const { data } = await axios(configResponseAPI)
    devicesAPI = data.data
    const combinedDevices = devicesDatabase.map(device => {
        const apiData = devicesAPI.find(api => api.terid === device.id);

        const cleanedGpsData = apiData
            ? {
                ...apiData,
                terid: undefined,
                gpslat: undefined,
                gpslng: undefined,
                altitude: undefined,
                speed: undefined,
                direction: undefined
            }
            : {}

        return {
            id: device.id,
            name: device.name,
            uniqueId: device.phone,
            status: device.device_status,
            latitude: apiData?.gpslat || null,
            longitude: apiData?.gpslng || null,
            altitude: apiData?.altitude || null,
            speed: apiData?.speed || 0,
            previousAngle: apiData?.direction || 0,
            fuel_id: device.fuel_id,
            km_per_liter: device.km_per_liter,
            is_dvr: device.is_dvr,
            channelcount: device.channelcount,
            status: device.status,
            last_update: device.last_update,
            imei: device.imei,
            created_at: device.created_at,
            attributes: {
                cleanedGpsData
            }
        }
    })
    return response.status(200).json({ error: false, data: combinedDevices });
}

export const geCamerasUrl = async (request, response) => {
    const { authorization } = request.headers;
    const { deviceId, channelcount } = request.body;
    const urls = [];

    try {
        // Verificar y desencriptar la clave
        const { key } = jwt.verify(authorization, process.env.SECRET_KEY);
        const decryptedKey = decrypt(key);

        // Consulta para obtener las cámaras asociadas al dispositivo
        const queryGetCameras = `
            SELECT dc.url, dc.last_updated
            FROM devices_cameras dc
            INNER JOIN device_camera dci ON dc.id = dci.camera_id
            WHERE dci.device_id = $1;
        `;
        const resultDevicesCameras = (await pool_db.query(queryGetCameras, [deviceId])).rows;

        // Función para realizar la solicitud a la API
        const fetchCameraData = async (channel) => {
            const response = await axios.get(`http://74.208.169.184:12056/api/v1/basic/live/video`, {
                params: {
                    key: decryptedKey,
                    terid: deviceId,
                    chl: channel + 1,
                    svrid: "127.0.0.1",
                    audio: 1,
                    st: 1,
                    port: 12060,
                },
            });
            return response.data;
        };

        // Función para actualizar o insertar en devices_cameras y asociarlo en device_camera
        const upsertCameraData = async (channel, url, isUpdate) => {
            if (isUpdate) {
                // Actualizar en devices_cameras
                const updateCameraQuery = `
                    UPDATE public.devices_cameras
                    SET url = $1, last_updated = $2
                    WHERE id = $3;
                `;
                await pool_db.query(updateCameraQuery, [url, new Date(), deviceId + channel]);
            } else {
                // Insertar en devices_cameras
                const insertCameraQuery = `
                    INSERT INTO public.devices_cameras (id, url, last_updated)
                    VALUES ($1, $2, $3);
                `;
                await pool_db.query(insertCameraQuery, [deviceId + channel, url, new Date()]);

                // Relacionar en device_camera
                const insertDeviceCameraQuery = `
                    INSERT INTO public.device_camera (device_id, camera_id)
                    VALUES ($1, $2)
                    ON CONFLICT DO NOTHING;
                `;
                await pool_db.query(insertDeviceCameraQuery, [deviceId, deviceId + channel]);
            }
        };

        // Verificar si se necesitan nuevas URLs o actualizar las existentes
        if (resultDevicesCameras.length === 0) {
            for (let i = 0; i < channelcount; i++) {
                try {
                    const cameraData = await fetchCameraData(i);
                    if (cameraData && cameraData.errorcode === 200) {
                        await upsertCameraData(i, cameraData.data.url, false);
                        urls.push(cameraData.data.url);
                    } else {
                        console.error(`Error en el canal ${i}:`, cameraData);
                    }
                } catch (error) {
                    console.error(`Error obteniendo datos de la cámara para el canal ${i}:`, error.message);
                }
            }
        } else {
            const isOutdated = (lastUpdated) =>
                (new Date() - new Date(lastUpdated)) / (1000 * 60 * 60 * 24) > 1;

            for (let i = 0; i < channelcount; i++) {
                if (isOutdated(resultDevicesCameras[i]?.last_updated)) {
                    try {
                        const cameraData = await fetchCameraData(i);
                        if (cameraData && cameraData.errorcode === 200) {
                            await upsertCameraData(i, cameraData.data.url, true);
                            urls.push(cameraData.data.url);
                        } else {
                            console.error(`Error en el canal ${i}:`, cameraData);
                        }
                    } catch (error) {
                        console.error(`Error obteniendo datos de la cámara para el canal ${i}:`, error.message);
                    }
                } else {
                    urls.push(resultDevicesCameras[i].url);
                }
            }
        }

        return response.status(200).json({ error: false, data: urls });
    } catch (error) {
        console.error("Error obteniendo cámaras:", error.message);
        return response.status(500).json({ error: true, message: "Error interno del servidor" });
    }
};

export const createTask = async (request, response) => {
    const { authorization } = request.headers;
    const { terid, starttime, endtime, chl, name } = request.body;
    let decryptedKey = '';
    let decoded;

    if (!authorization)
        return response.status(401).json({ error: true, data: 'auth_token_not_provided' });

    try {
        decoded = jwt.verify(authorization, process.env.SECRET_KEY);
    } catch (err) {
        return response.status(400).json({ error: true, data: 'jwt_malformed' });
    }

    const { key, id } = decoded;

    try {
        decryptedKey = decrypt(key);
    } catch (error) {
        return response.status(401).json({ error: true, msg: 'Decryption error' });
    }

    const configResponseAPI = {
        method: 'POST',
        url: 'http://74.208.169.184:12056/api/v1/basic/record/task',
        headers: {
            accept: 'application/json',
        },
        data: {
            key: decryptedKey,
            terid,
            starttime,
            endtime,
            chl,
            name,
            effective: 7,
            netmode: 4,
        },
    };

    const client = await pool_db.connect(); // Start a new database client

    try {
        // Step 1: Call the external API
        const responseAPI = (await axios(configResponseAPI)).data;
        const taskid = responseAPI.data.taskid;

        // Start database transaction
        await client.query('BEGIN');

        // Step 2: Insert into downloads table
        const insertDownloadsQuery = `
            INSERT INTO public.downloads(
                id, name, start_date, end_date, cameras, status_id, percentage, user_id)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8);
        `;
        await client.query(insertDownloadsQuery, [taskid, name, starttime, endtime, chl, -1, 0, id]);

        // Step 3: Insert into device_downloads table
        const insertDeviceDownloadsQuery = `
            INSERT INTO public.device_downloads(
                device_id, download_id)
            VALUES ($1, $2);
        `;
        await client.query(insertDeviceDownloadsQuery, [terid, taskid]);

        // Commit transaction
        await client.query('COMMIT');

        return response.status(200).json({ error: false, data: 'Task created successfully' });
    } catch (error) {
        // Rollback transaction in case of error
        await client.query('ROLLBACK');
        return response.status(500).json({ error: true, msg: `Error creating task: ${error.message}` });
    } finally {
        // Release database client
        client.release();
    }
};

export const getTasks = async (request, response) => {
    const { authorization } = request.headers
    const { terid } = request.params;

    if (!authorization)
        return response.status(401).json({ error: true, data: 'auth_token_not_provider' })

    try {
        jwt.verify(authorization, process.env.SECRET_KEY)
    } catch (err) {
        return response.status(400).json({ error: true, data: 'jwt_malformed' })
    }

    try {
        const queryTasks = `
        SELECT 
            d.id,
            d.name,
            d.start_date,
            d.end_date,
            d.cameras,
            d.percentage,
            s.status AS status,
            d.created_at,
            d.user_id
        FROM 
            downloads d
        INNER JOIN 
            device_downloads dd ON d.id = dd.download_id
        INNER JOIN 
            status_download s ON d.status_id = s.id
        WHERE 
            dd.device_id = $1;
        `

        const results = (await pool_db.query(queryTasks, [terid])).rows
        response.status(200).json({ error: false, data: results });
    } catch (error) {
        response.status(500).json({ error: true, data: error.message });
    }
}

export const getTaskStatus = async (request, response) => {
    const { authorization } = request.headers
    const { taskid, taskdate } = request.body;
    let decryptedKey = ''
    let decoded

    if (!authorization)
        return response.status(401).json({ error: true, data: 'auth_token_not_provider' })

    try {
        decoded = jwt.verify(authorization, process.env.SECRET_KEY)
    } catch (err) {
        return response.status(400).json({ error: true, data: 'jwt_malformed' })
    }

    const { key } = decoded

    try {
        decryptedKey = decrypt(key);
    } catch (error) {
        return res.status(401).json({ error: true, msg: 'Decryption error' });
    }

    try {
        const configResponseAPI = {
            method: 'POST',
            url: 'http://74.208.169.184:12056/api/v1/basic/record/taskstate',
            headers: {
                accept: 'application/json',
            },
            data: {
                key: decryptedKey,
                parms: [
                    {
                        taskid: taskid,
                        date: taskdate
                    }
                ]
            },
        };

        const responseAPI = (await axios(configResponseAPI)).data;
        const state = responseAPI.data[0].state
        const percentage = responseAPI.data[0].percent

        const queryTasks = `
            UPDATE public.downloads
	        SET percentage = $1, status_id = $2
	        WHERE id = $3;
        `
        pool_db.query(queryTasks, [percentage, state, taskid])

        const queryStatus = `
            SELECT 
                s.status AS status
            FROM 
                status_download s
            WHERE 
                s.id = $1;
        `

        const status = (await pool_db.query(queryStatus, [state])).rows[0].status

        response.status(200).json({ error: false, data: { status, percentage } });
    } catch (error) {
        response.status(500).json({ error: true, data: error.message });
    }
}

export const getVideoList = async (request, response) => {
    const { authorization } = request.headers;
    const { taskid } = request.params;
    let decryptedKey = ''
    let decoded

    if (!authorization)
        return response.status(401).json({ error: true, data: 'auth_token_not_provider' })

    try {
        decoded = jwt.verify(authorization, process.env.SECRET_KEY)
    } catch (err) {
        return response.status(400).json({ error: true, data: 'jwt_malformed' })
    }

    const { key } = decoded

    try {
        decryptedKey = decrypt(key);
    } catch (error) {
        return res.status(401).json({ error: true, msg: 'Decryption error' });
    }

    try {
        const configResponseAPI = {
            method: 'GET',
            url: `http://74.208.169.184:12056/api/v1/basic/record/taskfilelist?key=${decryptedKey}&taskid=${taskid}`,
            headers: {
                accept: 'application/json',
            }
        };

        const responseAPI = (await axios(configResponseAPI)).data;
        response.status(200).json({ error: false, data: responseAPI.data });
    } catch (error) {
        response.status(500).json({ error: true, data: error.message });
    }
}

export const downloadVideo = async (request, response) => {
    const { authorization } = request.headers;
    const { dir, name } = request.body;
    let decryptedKey = '';
    let decoded;

    if (!authorization) {
        return response.status(401).json({ error: true, data: 'auth_token_not_provider' });
    }

    try {
        decoded = jwt.verify(authorization, process.env.SECRET_KEY);
    } catch (err) {
        return response.status(400).json({ error: true, data: 'jwt_malformed' });
    }

    const { key } = decoded;

    try {
        decryptedKey = decrypt(key);
    } catch (error) {
        return response.status(401).json({ error: true, msg: 'Decryption error' });
    }

    try {
        const videoURL = `http://74.208.169.184:12056/api/v1/basic/record/download?key=${decryptedKey}&dir=${dir}&name=${name}`;
        response.setHeader('Content-Type', 'video/mp4');

        const videoStream = await axios({
            method: 'GET',
            url: videoURL,
            responseType: 'stream',
        });

        videoStream.data.pipe(response);
        videoStream.data.on('error', (err) => {
            console.error('Error in video streaming:', err);
            response.status(500).end();
        });
    } catch (error) {
        console.error('Error downloading video:', error.message);
        response.status(500).json({ error: true, data: error.message });
    }
};

export const deleteTask = async (request, response) => {
    const { authorization } = request.headers;
    const { taskid } = request.params;
    let decryptedKey = ''
    let decoded

    if (!authorization)
        return response.status(401).json({ error: true, data: 'auth_token_not_provider' })

    try {
        decoded = jwt.verify(authorization, process.env.SECRET_KEY)
    } catch (err) {
        return response.status(400).json({ error: true, data: 'jwt_malformed' })
    }

    const { key } = decoded

    try {
        decryptedKey = decrypt(key);
    } catch (error) {
        return res.status(401).json({ error: true, msg: 'Decryption error' });
    }

    const client = await pool_db.connect();

    try {
        const configRequestAPI = {
            method: 'DELETE',
            url: 'http://74.208.169.184:12056/api/v1/basic/record/task',
            headers: {
                accept: 'application/json',
            },
            data: {
                key: decryptedKey,
                parms: [
                    {
                        taskid: taskid,
                    },
                ],
            },
        };

        const responseAPI = (await axios(configRequestAPI)).data;

        if (!responseAPI.data[0].result) {
            return response.status(400).json({ error: true, data: 'Failed to delete task in external system' });
        }

        await client.query('BEGIN');

        const deleteDeviceDownloadsQuery = `
            DELETE FROM public.device_downloads
            WHERE download_id = $1;
        `;
        await client.query(deleteDeviceDownloadsQuery, [taskid]);

        const deleteDownloadsQuery = `
            DELETE FROM public.downloads
            WHERE id = $1;
        `;
        await client.query(deleteDownloadsQuery, [taskid]);
        await client.query('COMMIT');

        return response.status(200).json({ error: false, data: 'Task deleted successfully' });
    } catch (error) {
        await client.query('ROLLBACK');
        return response.status(500).json({ error: true, data: `Error deleting task: ${error.message}` });
    } finally {
        client.release();
    }
};
