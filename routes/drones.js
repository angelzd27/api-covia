import { Router } from 'express'
import { getDrones, allDrones, dronesByUserId } from '../controller/drones.js'

export const router_drones = Router()

router_drones.get('/drones-user', getDrones)
router_drones.get('/all-drones', allDrones)
router_drones.get('/drones-assigned/:id', dronesByUserId)