import { Router } from 'express'
import { geCamerasUrl, getDevices } from '../controller/devices.js'

export const router_devices = Router()

router_devices.get('/allDevices', getDevices)
router_devices.post('/getUrls', geCamerasUrl)