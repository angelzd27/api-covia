import { Router } from 'express'
import { gpsData, getCoordinates, setCoordinates, decodeData } from '../controller/ruptela.js'

export const router_ruptela = Router()

// Routes Ruptela
router_ruptela.post('/gps-data', gpsData)
router_ruptela.get('/get-coordinates', getCoordinates)
router_ruptela.get('/set-coordinates', setCoordinates)

// Decode Data
router_ruptela.post('/decode', decodeData)