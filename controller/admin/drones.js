import { pool_db } from '../../connection/connection.js'

export const allDrones = async (request, response) => {
    try {
        const query = `
            SELECT *
            FROM drones
            ORDER BY id ASC
        `
        const { rows } = await pool_db.query(query)
        return response.json({ error: false, data: rows })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const dronesAssigned = async (request, response) => {
    try {
        const { user_id } = request.body
        const query = `
            SELECT drones.id, drones.name, drones.latitude, drones.longitude
            FROM drones
            JOIN user_drone ON drones.id = user_drone.drone_id
            WHERE user_drone.user_id = $1 AND drones.status = true
        `
        const { rows } = await pool_db.query(query, [user_id])
        return response.json({ error: false, data: rows })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const assignDrone = async (request, response) => {
    try {
        const { user_id, drone_id } = request.body
        const query = `
            INSERT INTO user_drone (user_id, drone_id)
            VALUES ($1, $2)
        `
        await pool_db.query(query, [user_id, drone_id])
        return response.status(200).json({ error: false, data: 'drone_assigned' })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const unassignDrone = async (request, response) => {
    try {
        const { user_id, drone_id } = request.body
        const query = `
            DELETE FROM user_drone
            WHERE user_id = $1 AND drone_id = $2
        `
        await pool_db.query(query, [user_id, drone_id])
        return response.status(200).json({ error: false, data: 'drone_unassigned' })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}