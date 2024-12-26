import { pool_db } from '../../connection/connection.js'
import { decrypt } from '../../utils/encrypt.js'
import jwt from 'jsonwebtoken'
import { configDotenv } from 'dotenv'
import axios from 'axios'

configDotenv()

const JWT_SECRET = process.env.SECRET_KEY

export const allDevices = async (request, response) => {
    try {
        const groupsQuery = `
            SELECT *
            FROM groups
            WHERE status = true
            ORDER BY id ASC
        `
        const dataGroups = (await pool_db.query(groupsQuery)).rows
        const groupDevicesPromises = dataGroups.map(async (group) => {
            const queryDevices = `
                SELECT devices.*
                FROM devices
                JOIN group_device ON devices.id = group_device.device_id
                WHERE group_device.group_id = $1
                ORDER BY devices.last_update DESC
            `
            const dataDevices = (await pool_db.query(queryDevices, [group.id])).rows
            return {
                group_id: group.id,
                group: group.group,
                devices: dataDevices,
            }
        })
        const groupDevices = await Promise.all(groupDevicesPromises)
        return response.json({ error: false, data: groupDevices })
    } catch (error) {
        console.error('Error fetching or processing groups:', error)
        return response.status(500).json({ error: true, message: 'Internal Server Error' })
    }
}

export const createDevice = async (request, response) => {
    const { device_id, name, device_status, phone, model, fuel_id, km_per_liter, is_dvr, channelcount, imei, pad_lock, group_id } = request.body

    try {
        const query = `
            INSERT INTO devices (id, name, device_status, phone, model, fuel_id, km_per_liter, is_dvr, channelcount, imei, pad_lock)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
            RETURNING *
        `
        const data = (await pool_db.query(query, [device_id, name, device_status, phone, model, fuel_id, km_per_liter, is_dvr, channelcount, imei, pad_lock])).rows[0]

        if (group_id) {
            const queryGroupDevice = `
                INSERT INTO group_device (group_id, device_id)
                VALUES ($1, $2)
            `
            await pool_db.query(queryGroupDevice, [group_id, device_id])
        }

        return response.json({ error: false, data: data })
    } catch (error) {
        console.error('Error creating device:', error)
        return response.status(500).json({ error: true, message: 'Internal Server Error' })
    }
}

export const editGpsDevice = async (request, response) => {
    const { device_id, gps_id, group_id, channelcount, is_dvr } = request.body
    try {
        const query = `
            WITH deleted_group_device AS (
            DELETE FROM group_device
            WHERE device_id = $1
            ),
            updated_device AS (
            UPDATE devices
            SET id = $2, last_update = CURRENT_TIMESTAMP, channelcount = $4, is_dvr = $5
            WHERE id = $1
            RETURNING *
            )
            INSERT INTO group_device (group_id, device_id)
            VALUES ($3, $2)
        `
        await pool_db.query(query, [device_id, gps_id, group_id, channelcount, is_dvr])
        return response.json({ error: false, data: { msg: 'success' } })
    } catch (error) {
        console.error('Error editing device:', error)
        return response.status(500).json({ error: true, message: 'Internal Server Error' })
    }
}

export const editDevice = async (request, response) => {
    const { device_id, name, device_status, phone, model, fuel_id, km_per_liter, imei, pad_lock, channelcount, group_id } = request.body
    try {
        const query = `
            UPDATE devices
            SET name = $1, device_status = $2, phone = $3, model = $4, fuel_id = $5, km_per_liter = $6, imei = $7, pad_lock = $8, channelcount = $9, last_update = CURRENT_TIMESTAMP
            WHERE id = $10
            RETURNING *
        `
        const data = (await pool_db.query(query, [name, device_status, phone, model, fuel_id, km_per_liter, imei, pad_lock, channelcount, device_id])).rows[0]
        const queryGroupDevice = `
            DELETE FROM group_device
            WHERE device_id = $1
        `
        await pool_db.query(queryGroupDevice, [device_id])
        if (group_id) {
            const queryGroupDevice = `
                INSERT INTO group_device (group_id, device_id)
                VALUES ($1, $2)
            `
            await pool_db.query(queryGroupDevice, [group_id, device_id])
        }
        return response.json({ error: false, data: data })
    } catch (error) {
        console.error('Error editing device:', error)
        return response.status(500).json({ error: true, message: 'Internal Server Error' })
    }
}

export const deleteDevice = async (request, response) => {
    const { device_id } = request.body

    try {
        const queryDeleteGroupDevice = `
            DELETE FROM group_device
            WHERE device_id = $1
        `
        await pool_db.query(queryDeleteGroupDevice, [device_id])

        const queryUpdateDevice = `
            UPDATE devices
            SET status = false, id = CONCAT('DEL-', TO_CHAR(NOW(), 'YYYYMMDDHH24MISS'))
            WHERE id = $1
        `
        await pool_db.query(queryUpdateDevice, [device_id])

        return response.json({ error: false, message: 'Device deleted' })
    } catch (error) {
        console.error('Error deleting device:', error)
        return response.status(500).json({ error: true, message: 'Internal Server Error' })
    }
}

export const devicesUnassigned = async (request, response) => {
    try {
        const { authorization } = request.headers
        const decoded = jwt.verify(authorization, JWT_SECRET)
        const { key } = decoded
        const decryptedKey = decrypt(key)
        const configRequest = {
            method: 'GET',
            url: `http://74.208.169.184:12056/api/v1/basic/devices?key=${decryptedKey}`,
            headers: {
                'Content-Type': 'application/json',
            },
        }
        const { data } = await axios(configRequest)
        const queryDevices = `
            SELECT *
            FROM devices
            WHERE status = true
        `
        const { rows } = await pool_db.query(queryDevices)
        const unassignedDevices = data.data.filter((apiDevice) => !rows.some((device) => apiDevice.terid === device.id))
        return response.json({ error: false, data: unassignedDevices })
    } catch (error) {
        console.error('Error fetching unassigned devices:', error)
        return response.status(500).json({ error: true, message: 'Internal Server Error' })
    }
}