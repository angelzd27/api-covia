import { Router } from 'express'
import { deleteUser, getAllUsers, getUserById, updateUser } from '../controller/users'

export const router_users = Router()

router_hikvision.get('/getUsers', getAllUsers)
router_hikvision.get('/getUser:id', getUserById)
router_hikvision.put('/updateUser:id', updateUser)
router_hikvision.delete('/deleteUser:id', deleteUser)
