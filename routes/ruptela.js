import { Router } from 'express'
import { gpsData, getCoordinates, setCoordinates } from '../controller/ruptela.js'

export const router_ruptela = Router()

// Routes Ruptela
router_ruptela.post('/gps-data', gpsData)
router_ruptela.get('/get-coordinates', getCoordinates)
router_ruptela.get('/set-coordinates', setCoordinates)