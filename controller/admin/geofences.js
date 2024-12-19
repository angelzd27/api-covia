import { pool_db } from '../../connection/connection.js'

// Get all geofences
export const allGeofences = async (request, response) => {
    const query = `
        SELECT * 
        FROM geofences 
        WHERE status = true
        ORDER BY id ASC
    `
    const results = await pool_db.query(query)
    return response.json({ error: false, data: results.rows })
}

// Get geofences assigned to user
export const geofencesAssigned = async (request, response) => {
    const { user_id } = request.body
    const query = `
        SELECT geofences.*
        FROM geofences
        JOIN user_geofence ON geofences.id = user_geofence.geofence_id
        WHERE geofences.status = true AND user_geofence.user_id = $1
    `
    const result = (await pool_db.query(query, [user_id])).rows
    return response.status(200).json({ error: false, data: result })
}

// Assign Geofences
export const assignGeofence = async (request, response) => {
    const { user_id, geofence_id } = request.body
    const query = `
        INSERT INTO user_geofence (user_id, geofence_id)
        VALUES ($1, $2)
    `
    await pool_db.query(query, [user_id, geofence_id])
    return response.status(200).json({ error: false, data: 'geofence_assigned' })
}

// Unassign Geofences
export const unassignGeofence = async (request, response) => {
    const { user_id, geofence_id } = request.body
    const query = `
        DELETE FROM user_geofence
        WHERE user_id = $1 AND geofence_id = $2
    `
    await pool_db.query(query, [user_id, geofence_id])
    return response.status(200).json({ error: false, data: 'geofence_unassigned' })
}