import jwt from 'jsonwebtoken'
import { pool_db } from '../connection/connection.js'

export const getGeofences = async (request, response) => {
    const { authorization } = request.headers
    const { id } = jwt.verify(authorization, process.env.SECRET_KEY)
    const queryGeofences = `
        SELECT geofences.id, geofences.name, geofences.description, geofences.color, geofences.area
        FROM geofences
        INNER JOIN user_geofence ON geofences.id = user_geofence.geofence_id
        WHERE user_geofence.user_id = $1 AND geofences.status = true
    `
    const { rows } = await pool_db.query(queryGeofences, [id])

    return response.json({ error: false, data: rows })
}