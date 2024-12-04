import axios from 'axios'
import dotenv from 'dotenv'
import { pool_db } from '../connection/connection.js'
import { checkExpiration } from '../utils/expHikvision.js'

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
        headers: {
            'Content-Type': 'application/json',
            'Token': token
        },
        data: {
            type: type,
            code: code,
            deviceSerial: deviceSerial,
            resourceId: resourceId
        }
    }

    const requestData = await axios(url, requestOptions)

    return response.json(requestData.data)
}

// Get All Cameras usign HikVision API & Database
export const camerasList = async (request, response) => {
    const { token } = request.headers
    const { user_id } = request.body
    let allCameras = []



    const queryDVR = `SELECT nvr.id, nvr.name, nvr.app_key, nvr.secret_key, nvr.code, nvr.access_token, nvr.expired_token, nvr.streaming_token, nvr.address, nvr.city, nvr.camera_brand, nvr.contact, nvr.last_update
                      FROM nvr
                      JOIN user_nvr
                      ON nvr.id = user_nvr.nvr_id
                      WHERE status = true AND user_nvr.user_id = '${user_id}'`

    const rowsDVR = (await pool_db.query(queryDVR)).rows

    const updateTokenIfNeeded = async (nvr) => {
        const { expired_token } = nvr
        const check = checkExpiration(expired_token)

        if (check || !expired_token || expired_token === 'null' || expired_token === 'undefined', expired_token === '') {
            const urlGetToken = 'https://ius.hikcentralconnect.com/api/hccgw/platform/v1/token/get'
            const requestGetTokenOptions = {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                data: {
                    appKey: nvr.app_key,
                    secretKey: nvr.secret_key
                }
            }

            const requestData = (await axios(urlGetToken, requestGetTokenOptions)).data
            const newAccessToken = requestData.data.accessToken

            const urlGetStreamingToken = 'https://ius.hikcentralconnect.com/api/hccgw/platform/v1/streamtoken/get'
            const requestGetStreamingTokenOptions = {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Token': newAccessToken
                }
            }

            const requestStreamingTokenData = (await axios(urlGetStreamingToken, requestGetStreamingTokenOptions)).data
            const newStreamingToken = requestStreamingTokenData.data.appToken
            const newExpireTime = requestStreamingTokenData.data.expireTime

            const queryUpdateNVR = `UPDATE nvr
                                    SET access_token = '${newAccessToken}', expired_token = '${newExpireTime}', streaming_token = '${newStreamingToken}'
                                    WHERE id = ${nvr.id}`

            await pool_db.query(queryUpdateNVR)

            nvr.access_token = newAccessToken
            nvr.expired_token = newExpireTime
            nvr.streaming_token = newStreamingToken
        }
    }

    const getCameras = async (nvr) => {
        const urlGetCameras = 'https://ius.hikcentralconnect.com/api/hccgw/resource/v1/areas/cameras/get'
        const requestGetCamerasOptions = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Token': nvr.access_token
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

        const requestCamerasData = (await axios(urlGetCameras, requestGetCamerasOptions)).data
        return requestCamerasData.data.camera
    }

    const getStreamingUrl = async (nvr, camera) => {
        const urlGetStreaming = 'https://ius.hikcentralconnect.com/api/hccgw/video/v1/live/address/get'
        const requestGetStreamingOptions = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Token': nvr.access_token
            },
            data: {
                type: '1',
                code: nvr.code,
                deviceSerial: camera.deviceSerial,
                resourceId: camera.id
            }
        }

        const requestStreamingData = (await axios(urlGetStreaming, requestGetStreamingOptions)).data
        return requestStreamingData.data.url
    }

    for (const nvr of rowsDVR) {
        await updateTokenIfNeeded(nvr)
        const hikvisionCameras = await getCameras(nvr)

        const queryGetCameras = `SELECT cameras.id, cameras.name, cameras.latitude, cameras.longitude
                                 FROM cameras
                                 JOIN nvr_camera ON cameras.id = nvr_camera.camera_id
                                 WHERE nvr_camera.nvr_id = ${nvr.id} AND cameras.status = true`

        const rowsCameras = (await pool_db.query(queryGetCameras)).rows
        const mergedCameras = rowsCameras.map(camera => {
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
                streamToken: nvr.streaming_token,
                online: mergedCamera.online
            }
        })

        const cameraData = await Promise.all(streamingPromises)
        allCameras = allCameras.concat(cameraData)
    }

    return response.json({ error: false, data: allCameras })
}