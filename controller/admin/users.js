import { pool_db } from '../../connection/connection.js'
import bcrypt from 'bcrypt'

// Get all users from database
export const allUsers = async (request, response) => {
    try {
        const query = `
            SELECT id, first_name, last_name, email, phone, birthdate, last_update
            FROM users
            WHERE status = true
            ORDER BY last_update DESC
        `
        let queryResult = (await pool_db.query(query)).rows
        const userProfilesQuery = `
            SELECT p.id, p.profile 
            FROM profiles p
            INNER JOIN user_profile up ON p.id = up.profile_id
            WHERE up.user_id = $1
        `
        const userProfilesResult = await Promise.all(queryResult.map(async (user) => {
            const profiles = (await pool_db.query(userProfilesQuery, [user.id])).rows.map(profile => ({
                id: profile.id,
                profile: profile.profile
            }))
            return { ...user, profiles }
        }))
        return response.json({ error: false, data: userProfilesResult })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const editUser = async (request, response) => {
    try {
        const { user_id, first_name, last_name, email, phone, birthdate, profile_ids } = request.body
        const updateQuery = `
            UPDATE users
            SET first_name = $1, last_name = $2, email = $3, phone = $4, birthdate = $5, last_update = NOW()
            WHERE id = $6
            RETURNING *
        `
        let updatedUser = (await pool_db.query(updateQuery, [first_name, last_name, email, phone, birthdate, user_id])).rows[0]
        const deleteQuery = `
            DELETE FROM user_profile
            WHERE user_id = $1
        `
        await pool_db.query(deleteQuery, [user_id])
        const insertQuery = `
            INSERT INTO user_profile (user_id, profile_id)
            VALUES ($1, $2)
        `
        await Promise.all(profile_ids.map(async (profile_id) => {
            await pool_db.query(insertQuery, [user_id, profile_id])
        }))
        const userProfilesQuery = `
            SELECT p.id, p.profile 
            FROM profiles p
            INNER JOIN user_profile up ON p.id = up.profile_id
            WHERE up.user_id = $1
        `
        let userProfiles = (await pool_db.query(userProfilesQuery, [user_id])).rows.map(profile => ({
            id: profile.id,
            profile: profile.profile
        }))
        return response.json({ error: false, data: { ...updatedUser, profiles: userProfiles } })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const editPassword = async (request, response) => {
    try {
        const { user_id, password } = request.body
        const hashedPassword = await bcrypt.hash(password, 10)

        const query = `
            UPDATE users
            SET password = $1
            WHERE id = $2
        `
        await pool_db.query(query, [hashedPassword, user_id])
        return response.json({ error: false, data: 'password_updated' })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}

export const deleteUser = async (request, response) => {
    try {
        const { user_id } = request.body
        const updateQuery = `UPDATE users SET status = false WHERE id = $1`
        const deleteQueries = [
            `DELETE FROM user_profile WHERE user_id = $1`,
            `DELETE FROM user_group WHERE user_id = $1`,
            `DELETE FROM user_nvr WHERE user_id = $1`,
            `DELETE FROM user_drone WHERE user_id = $1`,
            `DELETE FROM user_geofence WHERE user_id = $1`
        ]

        await Promise.all(deleteQueries.map(query => pool_db.query(query, [user_id])))
        await pool_db.query(updateQuery, [user_id])

        return response.json({ error: false, data: 'user_deleted' })
    } catch (error) {
        return response.status(500).json({ error: true, data: error.message })
    }
}
