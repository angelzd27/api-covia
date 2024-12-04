import { Router } from 'express'
import { getDevices } from '../controller/devices.js'

export const router_devices = Router()

router_devices.get('/allDevices', getDevices)