import { Router } from 'express'
import { getGeofences, allGeofences, geofencesAssigned } from '../controller/geofences.js'

export const router_geofences = Router()

router_geofences.get('/get-geofences', getGeofences)
router_geofences.get('/all-geofences', allGeofences)
router_geofences.get('/geofences-assigned/:id', geofencesAssigned)