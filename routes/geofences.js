import { Router } from 'express'
import { getGeofences } from '../controller/geofences.js'

export const router_geofences = Router()

router_geofences.get('/get-geofences', getGeofences)
