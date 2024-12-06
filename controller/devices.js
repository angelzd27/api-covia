import { pool_db } from '../connection/connection.js';
import dotenv from 'dotenv';
import jwt from 'jsonwebtoken';
import axios from 'axios';

dotenv.config();

export const getDevices = async (request, response) => {
    const config = (token, devices) => ({
        method: 'POST',
        headers: {
            'accept': 'application/json',
        },
        data: {
            "key": token,
            "terid": devices
        }
    });
    try {
        const token = request.headers['authorization'];

        if (!token) {
            return response.status(401).json({ error: true, msg: 'authorization token is required' });
        }

        const decoded = jwt.verify(token, process.env.SECRET_KEY);
        const { id, key } = decoded;

        if (!id || !key) {
            return response.status(400).json({ error: true, msg: 'Invalid token structure' });
        }

        // Realizar la consulta
        const results = await pool_db.query(
            `
            SELECT d.* 
            FROM devices d
            INNER JOIN user_device ud ON d.id = ud.device_id
            WHERE ud.user_id = $1 AND d.status = $2
            `,
            [id, 'true']
        );

        const allDevices = results.rows.map(device => device.id);
        const apiResponse = await axios(`http://74.208.169.184:12056/api/v1/basic/gps/last`, config(key, allDevices));
        const combinedData = results.rows.map(device => {
            const apiData = apiResponse.data.data.find(api => api.terid === device.id);

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
                : {};

            return {
                id: device.id,
                name: device.name,
                uniqueId: device.phone || 'N/A',
                status: device.device_status || 'unknown',
                lastUpdate: device.last_update,
                latitude: apiData?.gpslat || null,
                longitude: apiData?.gpslng || null,
                altitude: apiData?.altitude || null,
                speed: apiData?.speed || 0,
                previousAngle: apiData?.direction || 0,
                channelcount: device.channelcount,
                attributes: {
                    cleanedGpsData
                }
            };
        });

        response.status(200).json({ error: false, data: combinedData });
    } catch (error) {
        if (error.name === 'JsonWebTokenError') {
            return response.status(401).json({ error: true, msg: 'Invalid token' });
        } else if (error.name === 'TokenExpiredError') {
            return response.status(401).json({ error: true, msg: 'Token expired' });
        } else {
            response.status(500).json({ error: true, msg: `Server internal error ${error}` });
        }
    }
};

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