import { pool_db } from '../connection/connection.js'
import jwt from 'jsonwebtoken'

export const getDrones = async (request, response) => {
    const { authorization } = request.headers

    if (!authorization) {
        return response.status(401).json({ error: true, data: 'auth_token_not_provided' })
    }

    try {
        const decoded = jwt.verify(authorization, process.env.SECRET_KEY)
        const { id } = decoded

        const query = `
            SELECT drones.id, drones.name, drones.latitude, drones.longitude
            FROM drones
            JOIN user_dron ON drones.id = user_dron.dron_id
            WHERE user_dron.user_id = $1 AND drones.status = true
        `
        const results = await pool_db.query(query, [id])

        return response.json({
            error: false,
            data: results.rows
        })
    } catch (err) {
        return response.status(400).json({ error: true, data: 'jwt_malformed' })
    }
}

export const allDrones = async (request, response) => {
    const query = 'SELECT * FROM drones WHERE status = true'
    const results = await pool_db.query(query)

    return response.json({ error: false, data: results.rows })
}

export const dronesByUserId = async (request, response) => {
    const { id } = request.params

    const query = `
        SELECT drones.id, drones.name, drones.latitude, drones.longitude
        FROM drones
        JOIN user_dron ON drones.id = user_dron.dron_id
        WHERE user_dron.user_id = $1 AND drones.status = true
    `
    const results = await pool_db.query(query, [id])

    return response.json({ error: false, data: results.rows })
}