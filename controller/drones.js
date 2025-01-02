import { pool_db } from '../connection/connection.js'
import jwt from 'jsonwebtoken'

export const getDrones = async (request, response) => {
    const { authorization } = request.headers
    const { id } = jwt.verify(authorization, process.env.SECRET_KEY)
    const query = `
        SELECT drones.id, drones.name, drones.latitude, drones.longitude
        FROM drones
        JOIN user_drone ON drones.id = user_drone.drone_id
        WHERE user_drone.user_id = $1 AND drones.status = true
    `
    const { rows } = await pool_db.query(query, [id])

    return response.json({ error: false, data: rows })
}