import { Router } from 'express'
import { geCamerasUrl, allDevices, allGroups, groupDevicesAssigned } from '../controller/devices.js'

export const router_devices = Router()

router_devices.get('/devices-user', allDevices)
router_devices.get('/all-groups', allGroups)
router_devices.post('/getUrls', geCamerasUrl)
router_devices.get('/groups-assigned/:id', groupDevicesAssigned)