import jwt from 'jsonwebtoken'
import { pool_db } from '../connection/connection.js'

export const getGeofences = async (request, response) => {
    const { authorization } = request.headers

    if (!authorization)
        return response.status(401).json({ error: true, data: 'auth_token_not_provider' })

    let decoded
    try {
        decoded = jwt.verify(authorization, process.env.SECRET_KEY)
    } catch (err) {
        return response.status(400).json({ error: true, data: 'jwt_malformed' })
    }

    const { id } = decoded

    let allGeofences = []

    const queryGeofences = `SELECT geofences.id, geofences.name, geofences.description, geofences.color, geofences.area
                            FROM geofences
                            INNER JOIN user_geofence ON geofences.id = user_geofence.geofence_id
                            WHERE user_geofence.user_id = $1 AND geofences.status = true`

    const results = (await pool_db.query(queryGeofences, [id])).rows
    allGeofences.push(...results)

    return response.json(allGeofences)
}

export const allGeofences = async (request, response) => {
    const query = 'SELECT * FROM geofences WHERE status = true'
    const results = await pool_db.query(query)

    return response.json({ error: false, data: results.rows })
}

export const geofencesAssigned = async (request, response) => {
    const { id } = request.params

    const query = `
        SELECT geofences.*
        FROM geofences
        JOIN user_geofence ON geofences.id = user_geofence.geofence_id
        WHERE geofences.status = true AND user_geofence.user_id = $1
    `

    const result = (await pool_db.query(query, [id])).rows

    return response.status(200).json({ error: false, data: result })
}