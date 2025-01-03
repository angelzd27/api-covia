import { Router } from 'express'
import { geCamerasUrl, allDevices, createTask, getTasks, getTaskStatus, deleteTask, getVideoList, downloadVideo } from '../controller/devices.js'

export const router_devices = Router()

router_devices.get('/devices-user', allDevices)
router_devices.post('/getUrls', geCamerasUrl)
router_devices.post('/createTask', createTask)
router_devices.get('/getTasks/:terid', getTasks)
router_devices.post('/getTaskStatus', getTaskStatus)
router_devices.get('/getVideoList/:taskid', getVideoList)
router_devices.post('/downloadVideo', downloadVideo)
router_devices.delete('/deleteTask/:taskid', deleteTask)
