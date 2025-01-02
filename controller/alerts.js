import { pool_db } from '../connection/connection.js'
import dotenv from 'dotenv'
import jwt from 'jsonwebtoken'

dotenv.config();

export const allAlerts = async (request, response) => {
    const query = `
        SELECT *
        FROM alert_type
        WHERE status = true
    `
    const { rows } = await pool_db.query(query)
    return response.status(200).json({ error: false, data: rows })
}