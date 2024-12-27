import { pool_db } from '../../connection/connection.js'

export const allGeofences = async (request, response) => {
    try {
        const query = `
            SELECT * 
            FROM geofences 
            WHERE status = true
            ORDER BY id ASC
        `
        const { rows } = await pool_db.query(query)
        return response.json({ error: false, data: rows })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const geofencesAssigned = async (request, response) => {
    try {
        const { user_id } = request.body
        const query = `
            SELECT geofences.*
            FROM geofences
            JOIN user_geofence ON geofences.id = user_geofence.geofence_id
            WHERE geofences.status = true AND user_geofence.user_id = $1
        `
        const { rows } = (await pool_db.query(query, [user_id]))
        return response.status(200).json({ error: false, data: rows })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const assignGeofence = async (request, response) => {
    try {
        const { user_id, geofence_id } = request.body
        const query = `
            INSERT INTO user_geofence (user_id, geofence_id)
            VALUES ($1, $2)
        `
        await pool_db.query(query, [user_id, geofence_id])
        return response.status(200).json({ error: false, data: 'geofence_assigned' })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const unassignGeofence = async (request, response) => {
    try {
        const { user_id, geofence_id } = request.body
        const query = `
            DELETE FROM user_geofence
            WHERE user_id = $1 AND geofence_id = $2
        `
        await pool_db.query(query, [user_id, geofence_id])
        return response.status(200).json({ error: false, data: 'geofence_unassigned' })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}