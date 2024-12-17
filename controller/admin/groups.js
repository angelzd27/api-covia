import { pool_db } from '../../connection/connection.js'

// Get all groups
export const allGroups = async (request, response) => {
    const query = `
        SELECT *
        FROM groups
        WHERE status = true
        ORDER BY id ASC
    `
    const result = (await pool_db.query(query)).rows
    return response.status(200).json({ error: false, data: result })
}

// Get groups assigned to user
export const groupsAssigned = async (request, response) => {
    const { user_id } = request.body
    const query = `
        SELECT groups.id, groups.group
        FROM groups
        JOIN user_group ON groups.id = user_group.group_id
        WHERE groups.status = true AND user_group.user_id = $1
    `
    const result = (await pool_db.query(query, [user_id])).rows
    return response.status(200).json({ error: false, data: result })
}

// Assign Group
export const assignGroup = async (request, response) => {
    const { user_id, group_id } = request.body
    const query = `
        INSERT INTO user_group (user_id, group_id)
        VALUES ($1, $2)
    `
    await pool_db.query(query, [user_id, group_id])
    return response.status(200).json({ error: false, data: 'group_assigned' })
}

// Unassign Group
export const unassignGroup = async (request, response) => {
    const { user_id, group_id } = request.body
    const query = `
        DELETE FROM user_group
        WHERE user_id = $1 AND group_id = $2
    `
    await pool_db.query(query, [user_id, group_id])
    return response.status(200).json({ error: false, data: 'group_unassigned' })
}