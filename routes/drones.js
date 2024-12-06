import { Router } from 'express'
import { getDrones } from '../controller/drones.js'

export const router_drones = Router()

router_drones.get('/all-drones', getDrones)