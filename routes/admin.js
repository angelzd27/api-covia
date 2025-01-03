import { Router } from 'express'
import { allUsers, editUser, editPassword, deleteUser } from '../controller/admin/users.js'
import { allNvr, nvrAssigned, assignNvr, unassignNvr } from '../controller/admin/nvr.js'
import { allGroups, groupsAssigned, assignGroup, unassignGroup, allGroupsWithTotalDevices, createGroup, deleteGroup, editGroup } from '../controller/admin/groups.js'
import { allGeofences, geofencesAssigned, assignGeofence, unassignGeofence } from '../controller/admin/geofences.js'
import { allDrones, dronesAssigned, assignDrone, unassignDrone } from '../controller/admin/drones.js'
import { allDevices, createDevice, editDevice, deleteDevice, devicesUnassigned, editGpsDevice } from '../controller/admin/devices.js'
import { infoDashboard } from '../controller/admin/dashboard.js'

export const router_admin = Router()

// Users Methods
router_admin.get('/all-users', allUsers)
router_admin.put('/edit-user', editUser)
router_admin.put('/edit-password', editPassword)
router_admin.delete('/delete-user', deleteUser)

// NVR Methods
router_admin.get('/all-nvr', allNvr)
router_admin.post('/nvr-assigned', nvrAssigned)
router_admin.post('/assign-nvr', assignNvr)
router_admin.delete('/unassign-nvr', unassignNvr)

// Group Devices Methods
router_admin.get('/all-groups', allGroups)
router_admin.post('/groups-assigned', groupsAssigned)
router_admin.post('/assign-group', assignGroup)
router_admin.delete('/unassign-group', unassignGroup)
router_admin.get('/all-groups-total-devices', allGroupsWithTotalDevices)
router_admin.post('/create-group', createGroup)
router_admin.put('/edit-group', editGroup)
router_admin.delete('/delete-group', deleteGroup)

// Geofences Methods
router_admin.get('/all-geofences', allGeofences)
router_admin.post('/geofences-assigned', geofencesAssigned)
router_admin.post('/assign-geofence', assignGeofence)
router_admin.delete('/unassign-geofence', unassignGeofence)

// Drones Methods
router_admin.get('/all-drones', allDrones)
router_admin.post('/drones-assigned', dronesAssigned)
router_admin.post('/assign-drone', assignDrone)
router_admin.delete('/unassign-drone', unassignDrone)

// Deiveces Methods
router_admin.get('/all-devices', allDevices)
router_admin.post('/create-device', createDevice)
router_admin.put('/edit-device', editDevice)
router_admin.put('/edit-gps', editGpsDevice)
router_admin.delete('/delete-device', deleteDevice)
router_admin.get('/devices-unassigned', devicesUnassigned)

// Dashboard Methods
router_admin.get('/info-dashboard', infoDashboard)