import { Router } from 'express'
import { getToken, getCamerasInfo, getStreamingToken, getStreaming, getCameraLive } from '../controller/hikvision.js'

export const router_hikvision = Router()

// Routes HikVision
router_hikvision.post('/get-token', getToken)
router_hikvision.post('/get-cameras', getCamerasInfo)
router_hikvision.get('/get-streaming-token', getStreamingToken)
router_hikvision.post('/get-streaming', getStreaming)

// Nueva ruta para obtener cámaras con URLs
router_hikvision.get('/get-camera-live', getCameraLive);