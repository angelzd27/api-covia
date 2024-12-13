import { pool_db } from '../connection/connection.js';
import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';
import axios from 'axios';

dotenv.config();

export const allDevices = async (request, response) => {
    const { authorization } = request.headers

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
            key: key,
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

export const allGroups = async (request, response) => {
    const query = `
        SELECT *
        FROM groups
        WHERE status = true
    `
    const result = (await pool_db.query(query)).rows
    return response.status(200).json({ error: false, data: result })
}

export const groupDevicesAssigned = async (request, response) => {
    const { id } = request.params

    const query = `
        SELECT groups.*
        FROM groups
        JOIN user_group ON groups.id = user_group.group_id
        WHERE groups.status = true AND user_group.user_id = $1
    `

    const result = (await pool_db.query(query, [id])).rows

    return response.status(200).json({ error: false, data: result })
}

export const geCamerasUrl = async (request, response) => {
    const { authorization } = request.headers
    const { deviceId, channelcount } = request.body;
    const urls = [];

    if (!authorization)
        return response.status(401).json({ error: true, data: 'auth_token_not_provider' })

    let decoded
    try {
        decoded = jwt.verify(authorization, process.env.SECRET_KEY)
    } catch (err) {
        return response.status(400).json({ error: true, data: 'jwt_malformed' })
    }

    const { key } = decoded

    try {
        for (let i = 0; i < channelcount; i++) {
            try {
                const response = await axios.get(
                    `http://74.208.169.184:12056/api/v1/basic/live/video?key=${key}&terid=${deviceId}&chl=${i + 1}&svrid=127.0.0.1&audio=1&st=1&port=12060`
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