import { Router } from 'express'
import { geCamerasUrl, allDevices } from '../controller/devices.js'

export const router_devices = Router()

router_devices.get('/devices-user', allDevices)
router_devices.post('/getUrls', geCamerasUrl)
