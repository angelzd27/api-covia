import { pool_db } from '../../connection/connection.js'

export const allGroups = async (request, response) => {
    try {
        const query = `
            SELECT *
            FROM groups
            WHERE status = true
            ORDER BY id ASC
        `
        const { rows } = await pool_db.query(query)
        return response.status(200).json({ error: false, data: rows })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const groupsAssigned = async (request, response) => {
    try {
        const { user_id } = request.body
        const query = `
            SELECT groups.id, groups.group
            FROM groups
            JOIN user_group ON groups.id = user_group.group_id
            WHERE groups.status = true AND user_group.user_id = $1
        `
        const { rows } = await pool_db.query(query, [user_id])
        return response.status(200).json({ error: false, data: rows })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const assignGroup = async (request, response) => {
    try {
        const { user_id, group_id } = request.body
        const query = `
            INSERT INTO user_group (user_id, group_id)
            VALUES ($1, $2)
        `
        await pool_db.query(query, [user_id, group_id])
        return response.status(200).json({ error: false, data: 'group_assigned' })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const unassignGroup = async (request, response) => {
    try {
        const { user_id, group_id } = request.body
        const query = `
            DELETE FROM user_group
            WHERE user_id = $1 AND group_id = $2
        `
        await pool_db.query(query, [user_id, group_id])
        return response.status(200).json({ error: false, data: 'group_unassigned' })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const allGroupsWithTotalDevices = async (request, response) => {
    try {
        const query = `
            SELECT groups.id, groups.group, COUNT(group_device.device_id) AS total_devices, groups.last_update
            FROM groups
            LEFT JOIN group_device ON groups.id = group_device.group_id
            WHERE groups.status = true
            GROUP BY groups.id
            ORDER BY last_update DESC
        `
        const { rows } = await pool_db.query(query)
        return response.status(200).json({ error: false, data: rows })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const createGroup = async (request, response) => {
    try {
        const { group } = request.body
        const query = `
            INSERT INTO groups ("group")
            VALUES ($1)
            RETURNING *
        `
        const { rows } = await pool_db.query(query, [group])
        return response.status(200).json({ error: false, data: rows[0] })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const editGroup = async (request, response) => {
    try {
        const { group_id, group } = request.body
        const query = `
            UPDATE groups
            SET "group" = $1, last_update = CURRENT_TIMESTAMP
            WHERE id = $2
            RETURNING *
        `
        const { rows } = await pool_db.query(query, [group, group_id])
        return response.status(200).json({ error: false, data: rows[0] })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const deleteGroup = async (request, response) => {
    try {
        const { group_id } = request.body
        const queryDevices = `
            DELETE FROM group_device
            WHERE group_id = $1
        `
        await pool_db.query(queryDevices, [group_id])
        const query = `
            UPDATE groups
            SET status = false
            WHERE id = $1
        `
        await pool_db.query(query, [group_id])
        return response.status(200).json({ error: false, data: 'group_deleted' })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}