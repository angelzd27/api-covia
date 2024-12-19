import { pool_db } from '../connection/connection.js'
import dotenv from 'dotenv'
import jwt from 'jsonwebtoken'

dotenv.config();

export const allAlerts = async (request, response) => {
    const { authorization } = request.headers

    if (!authorization)
        return response.status(401).json({ error: true, data: 'auth_token_not_provider' })

    try {
        jwt.verify(authorization, process.env.SECRET_KEY)
    } catch (err) {
        return response.status(400).json({ error: true, data: 'jwt_malformed' })
    }

    const query = `
        SELECT *
        FROM alert_type
        WHERE status = true
    `
    const result = (await pool_db.query(query)).rows
    return response.status(200).json({ error: false, data: result })
}