import { Router } from 'express'
import { deleteUser, getAllUsers, getUserById, updateUser } from '../controller/users.js'

export const router_users = Router()

router_users.get('/all-users', getAllUsers)
router_users.get('/getUser:id', getUserById)
router_users.put('/updateUser:id', updateUser)
router_users.delete('/deleteUser:id', deleteUser)
