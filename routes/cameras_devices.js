import { Router } from 'express'

export const cameras_devices_router = Router()

cameras_devices_router.get('/', (request, response) => {
    response.send('GET /cameras')
})