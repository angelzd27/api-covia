import axios from 'axios'
import dotenv from 'dotenv'
import { pool_db } from '../connection/connection.js'
import { checkExpiration } from '../utils/expHikvision.js'
import { crc16ccitt } from 'crc'
import jwt from 'jsonwebtoken'
import { encrypt, decrypt } from '../utils/encrypt.js'

dotenv.config()

// Get Token by AppKey and SecretKey
export const getToken = async (request, response) => {
    const { appKey, secretKey } = request.body
    const url = 'https://ius.hikcentralconnect.com/api/hccgw/platform/v1/token/get'

    const requestOptions = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        data: {
            appKey: appKey,
            secretKey: secretKey
        }
    }

    const requestData = await axios(url, requestOptions)

    return response.json(requestData.data)
}

// Get Cameras Info by Hikvision Token
export const getCamerasInfo = async (request, response) => {
    const { token } = request.headers
    const url = 'https://ius.hikcentralconnect.com/api/hccgw/resource/v1/areas/cameras/get'

    const requestOptions = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Token': token
        },
        data: {
            pageIndex: '1',
            pageSize: '150',
            filter: {
                areaID: '-1',
                includeSubArea: '1'
            }
        }
    }

    const requestData = await axios(url, requestOptions)

    return response.json(requestData.data)
}

// Get Streaming Token by Hikvision Token
export const getStreamingToken = async (request, response) => {
    const { token } = request.headers
    const url = 'https://ius.hikcentralconnect.com/api/hccgw/platform/v1/streamtoken/get'

    const requestOptions = {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'Token': token
        }
    }

    const requestData = await axios(url, requestOptions)

    return response.json(requestData.data)
}

// Get Streaming by Hikvision Token
export const getStreaming = async (request, response) => {
    const { token } = request.headers
    const { type, code, deviceSerial, resourceId } = request.body
    const url = 'https://ius.hikcentralconnect.com/api/hccgw/video/v1/live/address/get'

    const requestOptions = {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'Token': token },
        data: { type: type, code: code, deviceSerial: deviceSerial, resourceId: resourceId }
    }

    const requestData = await axios(url, requestOptions)
    return response.json(requestData.data)
}

export const camerasList = async (request, response) => {
    const updateTokenIfNeeded = async (nvr) => {
        const { last_update, app_key, secret_key } = nvr
        const lastUpdateDate = new Date(last_update)
        const currentDate = new Date()
        const oneDay = 24 * 60 * 60 * 1000
        const isOneDayPassed = (currentDate - lastUpdateDate) > oneDay

        if (isOneDayPassed) {
            const appKeyDecrypt = decrypt(app_key)
            const secretKeyDecrypt = decrypt(secret_key)
            const urlGetToken = 'https://ius.hikcentralconnect.com/api/hccgw/platform/v1/token/get'
            const requestGetTokenOptions = {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                data: { appKey: appKeyDecrypt, secretKey: secretKeyDecrypt }
            }

            const { data } = await axios(urlGetToken, requestGetTokenOptions)
            const newAccessToken = data.accessToken
            const urlGetStreamingToken = 'https://ius.hikcentralconnect.com/api/hccgw/platform/v1/streamtoken/get'
            const requestGetStreamingTokenOptions = {
                method: 'GET',
                headers: { 'Content-Type': 'application/json', 'Token': newAccessToken }
            }

            const requestStreamingTokenData = (await axios(urlGetStreamingToken, requestGetStreamingTokenOptions)).data
            const newStreamingToken = requestStreamingTokenData.data.appToken
            const newExpireTime = requestData.data.expireTime
            const newAppKeyEncrypt = encrypt(appKeyDecrypt)
            const newSecretKey = encrypt(secretKeyDecrypt)
            const queryUpdateNVR = `
                UPDATE nvr
                SET access_token = $1, expired_token = $2, streaming_token = $3, app_key = $4, secret_key = $5, last_update = CURRENT_TIMESTAMP
                WHERE id = $6
            `

            await pool_db.query(queryUpdateNVR, [newAccessToken, newExpireTime, newStreamingToken, newAppKeyEncrypt, newSecretKey, nvr.id])

            nvr.access_token = newAccessToken
            nvr.expired_token = newExpireTime
            nvr.streaming_token = newStreamingToken
        }
    }

    const getCameras = async (nvr) => {
        if (!nvr || !nvr.access_token) {
            throw new Error('Invalid NVR or access token')
        }

        const urlGetCameras = 'https://ius.hikcentralconnect.com/api/hccgw/resource/v1/areas/cameras/get'
        const requestGetCamerasOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Token': nvr.access_token },
            data: { pageIndex: '1', pageSize: '150', filter: { areaID: '-1', includeSubArea: '1' } }
        }

        const { data } = await axios(urlGetCameras, requestGetCamerasOptions)

        if (!data || !data.camera) {
            return []
        }

        return requestCamerasData.data.camera
    }

    const getStreamingUrl = async (nvr, camera) => {
        const urlGetStreaming = 'https://ius.hikcentralconnect.com/api/hccgw/video/v1/live/address/get'
        const requestGetStreamingOptions = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'Token': nvr.access_token },
            data: { type: '1', code: nvr.code, deviceSerial: camera.deviceSerial, resourceId: camera.id }
        }

        const requestStreamingData = (await axios(urlGetStreaming, requestGetStreamingOptions)).data

        if (requestStreamingData.errorCode != 0) {
            return ''
        }

        return requestStreamingData.data.url
    }

    const { authorization } = request.headers
    const { id } = jwt.verify(authorization, process.env.SECRET_KEY)
    let allCameras = []
    const queryDVR = `
        SELECT nvr.id, nvr.name, nvr.app_key, nvr.secret_key, nvr.code, nvr.access_token, nvr.expired_token, nvr.streaming_token, nvr.address, nvr.city, nvr.camera_brand, nvr.contact, nvr.last_update
        FROM nvr
        JOIN user_nvr
        ON nvr.id = user_nvr.nvr_id
        WHERE status = true AND user_nvr.user_id = $1
    `

    const { rows } = await pool_db.query(queryDVR, [id])

    for (const nvr of rows) {
        await updateTokenIfNeeded(nvr)
        const hikvisionCameras = await getCameras(nvr)
        const queryGetCameras = `
            SELECT cameras.id, cameras.name, cameras.latitude, cameras.longitude
            FROM cameras
            JOIN nvr_camera ON cameras.id = nvr_camera.camera_id
            WHERE nvr_camera.nvr_id = $1 AND cameras.status = true
        `

        const { rows } = await pool_db.query(queryGetCameras, [nvr.id])
        const mergedCameras = rows.map(camera => {
            const hikvisionCamera = hikvisionCameras.find(hikCam => hikCam.id === camera.id)
            if (hikvisionCamera) {
                return {
                    ...camera,
                    online: hikvisionCamera.online,
                    deviceSerial: hikvisionCamera.device.devInfo.serialNo
                }
            }
            return camera
        })

        const streamingPromises = mergedCameras.map(async (mergedCamera) => {
            const streamingUrl = await getStreamingUrl(nvr, mergedCamera)
            return {
                id: mergedCamera.id,
                name: mergedCamera.name,
                latitude: mergedCamera.latitude || "",
                longitude: mergedCamera.longitude || "",
                url: streamingUrl,
                token: streamingUrl ? nvr.streaming_token : '',
                online: streamingUrl ? true : false
            }
        })

        const cameraData = await Promise.all(streamingPromises)
        allCameras = allCameras.concat(cameraData)
    }

    return response.json({ error: false, data: allCameras })
}