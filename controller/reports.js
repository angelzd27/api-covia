import jwt from 'jsonwebtoken'
import { decrypt } from '../utils/encrypt.js';
import dotenv from 'dotenv';
import { pool_db } from '../connection/connection.js';
import axios from 'axios';

dotenv.config();
const serviceUrl = process.env.SERVICE_URL;

export const createReport = async (request, response) => {
    const { authorization } = request.headers
    const { devices, from, to } = request.body
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
        return response.status(401).json({ error: true, msg: 'Decryption error' });
    }

    try {
        const results = await getDeviceData({ ids: devices, from, to, key: decryptedKey });

        return response.json({
            error: false,
            data: results
        })
    } catch (err) {
        return response.status(400).json({ error: true, data: `summary error ${err}` })
    }
}

const getSummary = async ({ ids, from, to, key }) => {
    const results = [];
    const kilometersData = {}; // Objeto para almacenar los datos de kilometraje

    try {
        // 1. Realizar la solicitud a la API externa para obtener kilometraje
        const response = await axios.post(serviceUrl, {
            key: key,
            terid: ids,
            starttime: from,
            endtime: to
        });

        // 2. Manejar la respuesta de la API y organizar los datos
        if (response.data.errorcode === 200) {
            const apiData = response.data.data;
            for (const record of apiData) {
                const { terid, mileage } = record;
                const mileageInKm = parseFloat(mileage) * 1.60934; // Convertir millas a kilómetros

                if (!kilometersData[terid]) {
                    kilometersData[terid] = 0;
                }
                kilometersData[terid] += mileageInKm; // Sumar kilometraje para cada dispositivo
            }
        }

        // 3. Consultar la base de datos por cada ID
        for (const id of ids) {
            const query = `
                SELECT devices.id, devices.name, devices.km_per_liter 
                FROM devices 
                WHERE devices.id = $1 AND devices.status = true
            `;
            const result = (await pool_db.query(query, [id])).rows;
            if (result.length > 0) {
                const device = result[0];
                const kilometersTraveled = kilometersData[id] || 0; // Obtener el kilometraje acumulado
                const spentGas = kilometersTraveled / parseFloat(device.km_per_liter); // Calcular gasto de gasolina

                results.push({
                    ...device,
                    kilometers_traveled: kilometersTraveled.toFixed(2),
                    spent_gas: spentGas.toFixed(2)
                });
            }
        }

        return {
            error: false,
            data: results
        };

    } catch (error) {
        console.error('Error in getSummary:', error);
        return {
            error: true,
            msg: 'An error occurred while fetching summary data'
        };
    }
};

const getCoords = async ({ ids, from, to }) => {
    const results = [];

    try {
        // Ajustar el rango de fechas para incluir hasta el final del día en 'to'
        const adjustedTo = `${to} 23:59:59`;

        for (const id of ids) {
            const query = `
                SELECT latitude, longitude 
                FROM routes 
                WHERE device_id = $1 AND date >= $2 AND date <= $3
                ORDER BY date ASC
            `;
            const result = (await pool_db.query(query, [id, from, adjustedTo])).rows;
            const coords = result.map(row => [parseFloat(row.latitude), parseFloat(row.longitude)]);
            results.push({
                device_id: id,
                coords
            });
        }

        return results

    } catch (error) {
        console.error('Error in getCoords:', error);
        return {
            error: true,
            msg: 'An error occurred while fetching coordinates data'
        };
    }
};

const getAlerts = async ({ ids, from, to }) => {
    const results = [];

    try {
        const adjustedTo = `${to} 23:59:59`;

        // Obtener todas las categorías posibles de alert_type
        const categoryQuery = `SELECT alert AS category, color FROM alert_type`;
        const categoriesResult = (await pool_db.query(categoryQuery)).rows;
        const allCategories = categoriesResult.map(row => ({ category: row.category, color: row.color }));

        for (const id of ids) {
            const query = `
                SELECT at.alert AS category, at.color, COUNT(a.alert_id) AS value
                FROM alerts a
                JOIN alert_type at ON a.alert_id = at.id
                WHERE a.device_id = $1 AND a.date >= $2 AND a.date <= $3
                GROUP BY at.alert, at.color
            `;
            const result = (await pool_db.query(query, [id, from, adjustedTo])).rows;
            const categoryCounts = Object.fromEntries(
                result.map(row => [`${row.category}-${row.color}`, { value: parseInt(row.value), color: row.color }])
            );

            const eventCategories = allCategories.map(({ category, color }) => ({
                category,
                color,
                value: categoryCounts[`${category}-${color}`]?.value || 0
            }));

            results.push({
                deviceId: id,
                eventCategories
            });
        }

        return results

    } catch (error) {
        console.error('Error in getAlerts:', error);
        return {
            error: true,
            msg: 'An error occurred while fetching alerts data'
        };
    }
};

const getDeviceData = async ({ ids, from, to, key }) => {
    try {
        const [summary, coords, alerts] = await Promise.all([
            getSummary({ ids, from, to, key }),
            getCoords({ ids, from, to }),
            getAlerts({ ids, from, to })
        ]);

        const deviceData = ids.map(id => {
            const summaryData = (summary.data || []).find(device => device.id === id) || {};
            const coordsData = (coords || []).find(device => device.device_id === id) || { coords: [] };
            const alertsData = (alerts || []).find(device => device.deviceId === id) || { eventCategories: [] };
        
            return {
                deviceId: id,
                summary: summaryData,
                coordinates: coordsData.coords,
                alerts: alertsData.eventCategories
            };
        });

        return deviceData
    } catch (error) {
        console.error('Error in getDeviceData:', error);
        return {
            error: true,
            msg: 'An error occurred while fetching device data'
        };
    }
};