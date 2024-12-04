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
        // Obtener el token de los headers
        const token = request.headers['authorization'];

        if (!token) {
            return response.status(401).json({ error: true, msg: 'Authorization token is required' });
        }

        // Verificar y decodificar el token
        const decoded = jwt.verify(token, process.env.SECRET_KEY);

        // Extraer id y key del token
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

        // Unir los datos de results y apiResponse.data
        const combinedData = results.rows.map(device => {
            // Buscar el objeto de API que corresponde a este dispositivo
            const apiData = apiResponse.data.data.find(api => api.terid === device.id);

            // Combinar datos del dispositivo con datos de la API
            return {
                ...device,
                gpsData: apiData || null // Si no hay datos de GPS, asigna null
            };
        });

        // Responder con los resultados combinados
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
