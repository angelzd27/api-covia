import { Router } from 'express'
import { allAlerts } from '../controller/alerts.js'

export const router_alerts = Router()

router_alerts.get('/allAlerts', allAlerts)