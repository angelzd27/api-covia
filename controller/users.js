import { pool_db } from '../connection/connection.js'
import dotenv from 'dotenv'
import jwt from 'jsonwebtoken'
import bcrypt from 'bcrypt'

dotenv.config()

export const getUserById = async (request, response) => {
    try {
        const { authorization } = request.headers
        const data = jwt.verify(authorization, process.env.SECRET_KEY)
        const { id } = data
        const query = `
            SELECT id, first_name, last_name, email, phone, birthdate
            FROM users
            WHERE id = $1 AND status = true
        `
        const { rows } = await pool_db.query(query, [id])
        if (rows.length > 0) {
            rows[0].birthdate = rows[0].birthdate.toISOString().split('T')[0]
        }
        return response.json({ error: false, data: rows[0] })
    } catch (error) {
        console.error('Error fetching or processing user:', error)
        return response.status(500).json({ error: true, message: 'Internal Server Error' })
    }
}

export const updateUser = async (request, response) => {
    const { first_name, last_name, email, phone, birthdate } = request.body
    const { authorization } = request.headers
    try {
        const data = jwt.verify(authorization, process.env.SECRET_KEY)
        const { id } = data
        const query = `
            UPDATE users
            SET first_name = $1, last_name = $2, email = $3, phone = $4, birthdate = $5
            WHERE id = $6
            RETURNING *
        `
        await pool_db.query(query, [first_name, last_name, email, phone, birthdate, id])
        return response.json({ error: false, data: 'user_updated' })
    } catch (error) {
        console.error('Error updating user:', error)
        return response.status(500).json({ error: true, message: 'Internal Server Error' })
    }
}

export const updatePassword = async (request, response) => {
    const { authorization } = request.headers
    const { password } = request.body
    const hashedPassword = await bcrypt.hash(password, 10)
    const data = jwt.verify(authorization, process.env.SECRET_KEY)
    const query = `
        UPDATE users
        SET password = $1
        WHERE id = $2
    `
    try {
        await pool_db.query(query, [hashedPassword, data.id])
    } catch (err) {
        return response.status(500).json({ error: true, data: 'database_error' })
    }
    return response.json({ error: false, data: 'password_updated' })
}