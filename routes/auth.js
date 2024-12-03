import { Router } from 'express'
import { createUser, loginUser } from '../controller/auth.js'

export const router_auth = Router()

router_auth.post('/login', loginUser)
router_auth.post('/register', createUser)