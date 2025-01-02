import { pool_db } from '../../connection/connection.js'

export const infoDashboard = async (request, response) => {
    const queries = {
        totalNvr: 'SELECT COUNT(*) AS total FROM nvr',
        totalDevices: 'SELECT COUNT(*) AS total FROM devices',
        totalGeofences: 'SELECT COUNT(*) AS total FROM geofences',
        totalDrones: 'SELECT COUNT(*) AS total FROM drones',
        totalUsers: 'SELECT COUNT(*) AS total FROM users',
        totalProfiles: 'SELECT profiles.id, COUNT(user_profile.profile_id) AS total FROM profiles JOIN user_profile ON profiles.id = user_profile.profile_id JOIN users ON user_profile.user_id = users.id WHERE users.status = true GROUP BY profiles.id, profiles.profile',
        totalGroups: 'SELECT groups.group, COUNT(group_device.device_id) AS total FROM groups JOIN group_device ON groups.id = group_device.group_id WHERE groups.status = true GROUP BY groups.id ORDER BY last_update DESC',
        dataGraphic: 'SELECT at.alert AS category, COUNT(a.alert_id) AS total, at.color FROM alerts a JOIN alert_type at ON a.alert_id = at.id GROUP BY at.alert, at.color',
        nvrDetails: 'SELECT nvr.name, nvr.address, nvr.city, COUNT(nvr_camera.camera_id) AS total_cameras FROM nvr JOIN nvr_camera ON nvr.id = nvr_camera.nvr_id GROUP BY nvr.name, nvr.address, nvr.city',
    }

    let totalEquipments = { totalNvr: 0, totalDevices: 0, totalPanicButtons: 0, totalTotems: 0, totalGeofences: 0, totalDrones: 0, totalRadios: 0, totalBodyCams: 0, }
    let totalUsers = 0
    let totalProfiles = []
    let totalGroups = []
    let totalDataGraphic = []
    let totalNvr = []

    try {
        const results = await Promise.all(Object.values(queries).map(query => pool_db.query(query)))

        totalEquipments.totalNvr = results[0].rows[0].total
        totalEquipments.totalDevices = results[1].rows[0].total
        totalEquipments.totalGeofences = results[2].rows[0].total
        totalEquipments.totalDrones = results[3].rows[0].total
        totalUsers = results[4].rows[0].total
        totalProfiles = results[5].rows
        totalGroups = results[6].rows
        totalDataGraphic = results[7].rows.map(row => ({
            category: row.category,
            total: parseInt(row.total, 10),
            color: row.color
        }))
        totalNvr = results[8].rows

        response.status(200).json({
            error: false,
            data: {
                totalEquipments: totalEquipments,
                totalUsers: totalUsers,
                totalProfiles: totalProfiles,
                totalGroups: totalGroups,
                totalDataGraphic: totalDataGraphic,
                totalNvr: totalNvr
            }
        })
    } catch (error) {
        response.status(500).json({ message: error.message })
    }
}
