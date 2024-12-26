import { Router } from 'express'
import { getUserById, updateUser, updatePassword } from '../controller/users.js'

export const router_users = Router()

router_users.get('/user-by-id', getUserById)
router_users.put('/update-user', updateUser)
router_users.put('/update-password', updatePassword)