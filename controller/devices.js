import { pool_db } from '../connection/connection.js';
import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';
import axios from 'axios';
import { decrypt } from '../utils/encrypt.js';

dotenv.config();

export const allDevices = async (request, response) => {
    const { authorization } = request.headers
    var decryptedKey = ''

    if (!authorization)
        return response.status(401).json({ error: true, data: 'auth_token_not_provider' })

    let decoded
    let devicesDatabase = []
    let devicesAPI = []

    try {
        decoded = jwt.verify(authorization, process.env.SECRET_KEY)
    } catch (err) {
        return response.status(400).json({ error: true, data: 'jwt_malformed' })
    }

    const { id, key } = decoded

    try {
        decryptedKey = decrypt(key);
    } catch (error) {
        return res.status(401).json({ error: true, msg: 'Decryption error' });
    }

    const queryGetGroups = `
        SELECT groups.id, groups.group
        FROM groups
        JOIN user_group ON groups.id = user_group.group_id
        WHERE groups.status = true AND user_group.user_id = $1
    `

    const resultGroups = (await pool_db.query(queryGetGroups, [id])).rows

    for (const group of resultGroups) {
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
        headers: {
            'accept': 'application/json',
        },
        data: {
            key: decryptedKey,
            terid: devicesDatabase.map(device => device.id)
        }
    }

    const responseAPI = (await axios(configResponseAPI)).data

    devicesAPI = responseAPI.data

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
    const { authorization } = request.headers
    const { deviceId, channelcount } = request.body;
    const urls = [];
    var decryptedKey = '';
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
        for (let i = 0; i < channelcount; i++) {
            try {
                const response = await axios.get(
                    `http://74.208.169.184:12056/api/v1/basic/live/video?key=${decryptedKey}&terid=${deviceId}&chl=${i + 1}&svrid=127.0.0.1&audio=1&st=1&port=12060`
                );

                if (response.data && response.data.errorcode === 200) {
                    urls.push(response.data.data.url); // Agrega la URL al arreglo
                } else {
                    console.error(`Error en el canal ${i}:`, response.data);
                }
            } catch (error) {
                console.error(`Error en la consulta del canal ${i}:`, error.message);
            }
        }

        response.status(200).json({ error: false, data: urls });
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

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

    const { key } = decoded;

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
                id, name, start_date, end_date, cameras, status_id, percentage)
            VALUES ($1, $2, $3, $4, $5, $6, $7);
        `;
        await client.query(insertDownloadsQuery, [taskid, name, starttime, endtime, chl, -1, 0]);

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
            d.dir,
            d.dirname,
            d.created_at
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

        response.status(200).json({ error: false, data: {status, percentage} });
    } catch (error) {
        response.status(500).json({ error: true, data: error.message });
    }
}