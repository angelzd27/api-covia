import { Router } from 'express'
import { createReport } from '../controller/reports.js'

export const router_reports = Router()

router_reports.post('/generate', createReport)