import { pool_db } from '../../connection/connection.js'
import bcrypt from 'bcrypt'

// Get all users from database
export const allUsers = async (request, response) => {
    const query = `
        SELECT *
        FROM users
        WHERE status = true
        ORDER BY last_update DESC
    `
    let queryResult;
    try {
        queryResult = (await pool_db.query(query)).rows
    } catch (err) {
        return response.status(500).json({ error: true, data: 'database_error' })
    }
    const userProfilesQuery = `
        SELECT p.id, p.profile 
        FROM profiles p
        INNER JOIN user_profile up ON p.id = up.profile_id
        WHERE up.user_id = $1
    `
    const userProfilesResult = await Promise.all(queryResult.map(async (user) => {
        const profiles = (await pool_db.query(userProfilesQuery, [user.id])).rows.map(profile => ({
            id: profile.id,
            profile_ids: profile.profile
        }))
        return { ...user, profiles }
    }))
    return response.json({ error: false, data: userProfilesResult })
}

export const editUser = async (request, response) => {
    const { user_id, first_name, last_name, email, phone, birthdate, profile_ids } = request.body
    const updateQuery = `
        UPDATE users
        SET first_name = $1, last_name = $2, email = $3, phone = $4, birthdate = $5, last_update = NOW()
        WHERE id = $6
        RETURNING *
    `
    let updatedUser;
    try {
        updatedUser = (await pool_db.query(updateQuery, [first_name, last_name, email, phone, birthdate, user_id])).rows[0]
    } catch (err) {
        return response.status(500).json({ error: true, data: 'database_error' })
    }
    const deleteQuery = `
        DELETE FROM user_profile
        WHERE user_id = $1
    `
    try {
        await pool_db.query(deleteQuery, [user_id])
    } catch (err) {
        return response.status(500).json({ error: true, data: 'database_error' })
    }
    const insertQuery = `
        INSERT INTO user_profile (user_id, profile_id)
        VALUES ($1, $2)
    `
    try {
        await Promise.all(profile_ids.map(async (profile_id) => {
            await pool_db.query(insertQuery, [user_id, profile_id])
        }))
    } catch (err) {
        return response.status(500).json({ error: true, data: 'database_error' })
    }
    const userProfilesQuery = `
        SELECT p.id, p.profile 
        FROM profiles p
        INNER JOIN user_profile up ON p.id = up.profile_id
        WHERE up.user_id = $1
    `
    let userProfiles;
    try {
        userProfiles = (await pool_db.query(userProfilesQuery, [user_id])).rows.map(profile => ({
            id: profile.id,
            profile: profile.profile
        }))
    } catch (err) {
        return response.status(500).json({ error: true, data: 'database_error' })
    }
    return response.json({ error: false, data: { ...updatedUser, profile_ids: userProfiles } })
}

export const editPassword = async (request, response) => {
    const { user_id, password } = request.body
    const hashedPassword = await bcrypt.hash(password, 10)

    const query = `
        UPDATE users
        SET password = $1
        WHERE id = $2
    `
    try {
        await pool_db.query(query, [hashedPassword, user_id])
    } catch (err) {
        return response.status(500).json({ error: true, data: 'database_error' })
    }
    return response.json({ error: false, data: 'password_updated' })
}

export const deleteUser = async (request, response) => {
    const { user_id } = request.body
    const query = `
        UPDATE users
        SET status = false
        WHERE id = $1
    `
    try {
        await pool_db.query(query, [user_id])
    } catch (err) {
        return response.status(500).json({ error: true, data: 'database_error' })
    }
    return response.json({ error: false, data: 'user_deleted' })
}