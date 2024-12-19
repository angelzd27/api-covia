import { pool_db } from '../../connection/connection.js'

export const allDevices = async (request, response) => {
    try {
        const groupsQuery = `
            SELECT *
            FROM groups
            WHERE status = true
            ORDER BY id ASC
        `
        const dataGroups = (await pool_db.query(groupsQuery)).rows
        const unassignedDevicesQuery = `
            SELECT devices.*
            FROM devices
            LEFT JOIN group_device ON devices.id = group_device.device_id
            WHERE group_device.device_id IS NULL
        `
        const unassignedDevices = (await pool_db.query(unassignedDevicesQuery)).rows
        const groupDevicesPromises = dataGroups.map(async (group) => {
            const queryDevices = `
                SELECT devices.*
                FROM devices
                JOIN group_device ON devices.id = group_device.device_id
                WHERE group_device.group_id = $1
            `
            const dataDevices = (await pool_db.query(queryDevices, [group.id])).rows
            return {
                group_id: group.id,
                group: group.group,
                devices: dataDevices,
            }
        })
        const groupDevices = await Promise.all(groupDevicesPromises)
        if (unassignedDevices.length > 0) {
            groupDevices.push({
                group_id: null,
                group: 'Lost',
                devices: unassignedDevices,
            })
        }
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
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
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