import { pool_db } from '../../connection/connection.js'

export const allNvr = async (request, response) => {
    const query = `
        SELECT *
        FROM nvr
        ORDER BY id ASC
    `
    const rows = (await pool_db.query(query)).rows
    return response.json({ error: false, data: rows })
}

export const nvrAssigned = async (request, response) => {
    const { user_id } = request.body
    const query = `
        SELECT nvr.id, nvr.name
        FROM nvr
        JOIN user_nvr
        ON nvr.id = user_nvr.nvr_id
        WHERE user_nvr.user_id = $1
        ORDER BY nvr.id ASC
    `
    const rows = (await pool_db.query(query, [user_id])).rows
    return response.json({ error: false, data: rows })
}

// Assign NVR
export const assignNvr = async (request, response) => {
    const { user_id, nvr_id } = request.body
    const query = `
        INSERT INTO user_nvr (user_id, nvr_id)
        VALUES ($1, $2)
    `
    await pool_db.query(query, [user_id, nvr_id])
    return response.status(200).json({ error: false, data: 'nvr_assigned' })
}

// Unssign NVR
export const unassignNvr = async (request, response) => {
    const { user_id, nvr_id } = request.body
    const query = `
        DELETE FROM user_nvr
        WHERE user_id = $1 AND nvr_id = $2
    `
    await pool_db.query(query, [user_id, nvr_id])
    return response.status(200).json({ error: false, data: 'nvr_unassigned' })
}