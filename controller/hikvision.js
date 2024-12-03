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

// Ruta para obtener toda la información de cámaras y streams
export const getCameraLive = async (request, response) => {
    const cameraCoordinates = {
        //casa de quino
        "HELIPUERTO TRASERA": { latitude: "20.701784", longitude: "-100.196503" },
        "BODEGA GENERAL": { latitude: "20.702702", longitude: "-100.196868" },
        "HELIPUERTO FRENTE": { latitude: "20.701945", longitude: "-100.196534" },
        "VIÑEDOS RESTAURANTE": { latitude: "20.702540", longitude: "-100.196750" },
        "RODEO": { latitude: "20.702756", longitude: "-100.196700" },
        "INVERNADERO": { latitude: "20.702733", longitude: "-100.196930" },
        "COCINA": { latitude: "20.702687", longitude: "-100.196518" },
        "ESTACIONAMIENTO LADO CABALLERIZA": { latitude: "20.702600", longitude: "-100.196446" },
        "ACCESO BARRICAS": { latitude: "20.702728", longitude: "-100.196744" },
        "BODEGA COCINA": { latitude: "20.702737", longitude: "-100.196466" },
        "ACCESO BAÑOS": { latitude: "20.702768", longitude: "-100.196758" },
        "BAR": { latitude: "20.702860", longitude: "-100.196441" },
        "ESTACIONAMIENTO LADO HELIPUERTO": { latitude: "20.702613", longitude: "-100.196468" },
        "CABALLERIZAS": { latitude: "20.702722", longitude: "-100.196914" },
        "RESTAURANTE": { latitude: "20.702746", longitude: "-100.196643" },
        "CAMINO A CASETA 3": { latitude: "20.703208", longitude: "-100.196828" },
        "ATRAS RESTAURANTE": { latitude: "20.702723", longitude: "-100.196866" },
        "CAMINO A FINCA": { latitude: "20.702955", longitude: "-100.196825" },
        "CUARTO DE JUEGOS": { latitude: "20.702693", longitude: "-100.196834" },
        "ENTRADA A FABRICA 1": { latitude: "20.703118", longitude: "-100.196711" },
        "ENTRADA A FABRICA 2": { latitude: "20.703123", longitude: "-100.196614" },
        "CANCHAS": { latitude: "20.702655", longitude: "-100.196466" },
        //cancun
        "PALAPA": { latitude: "21.113561", longitude: "-86.977110" },
        "FRENTE ESTE": { latitude: "21.114253", longitude: "-86.977046" },
        "FRENTE OESTE": { latitude: "21.114626", longitude: "-86.977914" },
        "PLUMA Y CUARTOS": { latitude: "21.114257", longitude: "-86.977293" },
        "AUDITORIO": { latitude: "21.112852", longitude: "-86.977052" },
        "ENTRADA OESTE": { latitude: "21.112219", longitude: "-86.977562" },
        "PASILLO 2": { latitude: "21.114124", longitude: "-86.977084" },
        "ACCESO PLUMA": { latitude: "21.112503", longitude: "-86.977122" },
        "PASILLO GYM": { latitude: "21.113105", longitude: "-86.977106" },
        "CANCHAS SUR": { latitude: "21.112505", longitude: "-86.977492" },
        "CANCHAS NORTE": { latitude: "21.114662", longitude: "-86.977666" },
        "GYM": { latitude: "21.113080", longitude: "-86.977050" },
        "RECEPCION": { latitude: "21.112525", longitude: "-86.977108" },
        "IPCamera 07": { latitude: "21.113196", longitude: "-86.977736" },
        "CANCHA PADEL": { latitude: "21.113402", longitude: "-86.977321" },
        "ACCESO ALBERCA": { latitude: "21.113776", longitude: "-86.977321" },
        "GYM EJECUTIVO": { latitude: "21.112440", longitude: "-86.977312" },
        "ACCESO PRINCIPAL": { latitude: "21.112563", longitude: "-86.977197" },
        "OFNA SUPERIOR": { latitude: "21.112588", longitude: "-86.977083" },
        "Camera 01": { latitude: "21.114544", longitude: "-86.977390" },
        "ALMACEN": { latitude: "21.113686", longitude: "-86.977085" },
        "CUARTOS": { latitude: "21.114121", longitude: "-86.977387" },
        "ENTRADA ESTE": { latitude: "21.114875", longitude: "-86.977141" },
        "FRENTE": { latitude: "21.114254", longitude: "-86.977107" },
        "PERIMETRO": { latitude: "21.112572", longitude: "-86.977183" },
        "EXT SUP ESTE": { latitude: "21.115011", longitude: "-86.977139" },
        "LAVANDERIA": { latitude: "21.113580", longitude: "-86.977210" },
        "CANCHA TENIS": { latitude: "21.114628", longitude: "-86.977822" },
        "PASILLO 1": { latitude: "21.113802", longitude: "-86.977353" },
        "OFNA INFERIOR": { latitude: "21.114164", longitude: "-86.977135" },
        "OFICINA DOMO": { latitude: "21.112581", longitude: "-86.977178" },
        "FONDO": { latitude: "21.112434", longitude: "-86.977246" },
        //casa chorro
        "Garage": { latitude: "20.909147", longitude: "-100.740707" },
        "Jardin": { latitude: "20.909252", longitude: "-100.740658" },
        "Terraza": { latitude: "20.909228", longitude: "-100.740561" },
        "Entrada Principal": { latitude: "20.909170", longitude: "-100.740494" },
        "Chorro 1": { latitude: "20.909168", longitude: "-100.740531" },
        "Entrada Lavanderia": { latitude: "20.909111", longitude: "-100.740573" },
        "Arco": { latitude: "20.909142", longitude: "-100.740647" },
        "Bajada explanada": { latitude: "20.909104", longitude: "-100.740759" },
        "Pasillo lavanderia": { latitude: "20.909145", longitude: "-100.740545" },
        "Lavanderia": { latitude: "20.909144", longitude: "-100.740579" },
        "Entrada explanada": { latitude: "20.909680", longitude: "-100.740873" },
        "Chorro 2": { latitude: "20.909288", longitude: "-100.740474" },
        "Explanada": { latitude: "20.909828", longitude: "-100.740794" },
        "Playa": { latitude: "20.909336", longitude: "-100.740652" },
        "Rampa 1": { latitude: "20.909159", longitude: "-100.740744" },
        "IPCamera 10": { latitude: "20.909417", longitude: "-100.740826" },
        "IPCamera 09": { latitude: "20.909525", longitude: "-100.740675" },
        "Asador": { latitude: "20.909384", longitude: "-100.740807" },
        "Caseta 1": { latitude: "20.909319", longitude: "-100.740518" },
        "Rampa 2": { latitude: "20.909124", longitude: "-100.740759" },
        "Camera 01": { latitude: "20.909092", longitude: "-100.740657" },
        "Asador 2": { latitude: "20.909149", longitude: "-100.740524" },
        "Caseta 2": { latitude: "20.909097", longitude: "-100.740686" },
        "Hiperbarica": { latitude: "20.909256", longitude: "-100.740512" },
        "Entrada principal": { latitude: "20.909105", longitude: "-100.740582" },
        "Puerta Cochera": { latitude: "20.909085", longitude: "-100.740722" },
        "Cochera": { latitude: "20.909273", longitude: "-100.740800" },
        "Vecino": { latitude: "20.909057", longitude: "-100.740633" }
    }

    try {
        // Paso 1: Obtener las credenciales desde el archivo .env
        const appKey = process.env.APP_KEY
        const secretKey = process.env.SECRET_KEY

        if (!appKey || !secretKey) {
            return response.status(500).json({ error: 'APP_KEY y SECRET_KEY no están configurados' })
        }

        // Paso 2: Obtener el token de acceso
        const tokenResponse = await axios.post(
            'https://ius.hikcentralconnect.com/api/hccgw/platform/v1/token/get',
            { appKey, secretKey },
            { headers: { 'Content-Type': 'application/json' } }
        )
        const accessToken = tokenResponse.data?.data?.accessToken

        if (!accessToken) {
            return response.status(500).json({ error: 'No se pudo obtener el token de acceso' })
        }

        // Paso 3: Obtener la información de las cámaras
        const requestOptions = {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Token': accessToken
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

        const camerasResponse = await axios('https://ius.hikcentralconnect.com/api/hccgw/resource/v1/areas/cameras/get', requestOptions)
        const cameras = camerasResponse.data?.data?.camera || []

        if (cameras.length === 0) {
            return response.status(200).json({ message: 'No se encontraron cámaras', data: [] })
        }

        // Paso 4: Obtener el token de streaming
        const streamTokenResponse = await axios("https://ius.hikcentralconnect.com/api/hccgw/platform/v1/streamtoken/get", {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Token': accessToken
            }
        })
        const streamToken = streamTokenResponse.data?.data?.appToken

        if (!streamToken) {
            return response.status(500).json({ error: 'No se pudo obtener el token de streaming' })
        }

        // Paso 5: Obtener las URLs de streaming para cada cámaras
        const dataCameras = []
        for (const camera of cameras) {
            const { name, id, device } = camera
            const deviceSerial = device?.devInfo?.serialNo

            const requestCamOpt = {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Token': accessToken
                },
                data: {
                    type: "1",
                    code: "EmvyG8",
                    deviceSerial,
                    resourceId: id
                }
            }

            try {
                const streamingResponse = await axios.post(
                    'https://ius.hikcentralconnect.com/api/hccgw/video/v1/live/address/get',
                    requestCamOpt.data,
                    { headers: requestCamOpt.headers }
                )

                const streamingUrl = streamingResponse.data?.data?.url

                if (streamingUrl) {
                    const coordinates = cameraCoordinates[name]

                    if (coordinates) {
                        dataCameras.push({
                            id,
                            name,
                            url: streamingUrl,
                            token: streamToken,
                            latitude: coordinates.latitude,
                            longitude: coordinates.longitude
                        })
                    } else {
                        console.warn(`No se encontró latitud/longitud para la cámara: ${name}`)
                    }
                }
            } catch (error) {
                console.error(`Error obteniendo streaming para la cámara ${name}:`, error.message)
            }
        }

        // Paso 6: Responder con el arreglo de objetos
        return response.status(200).json(dataCameras)
    } catch (error) {
        console.error('Error en getCameraLive:', error.message)
        return response.status(500).json({ error: 'Error al procesar la solicitud' })
    }
}

export const camerasList = async (request, response) => {
    const { user_id } = request.body
    let allCameras = []

    const queryDVR = `SELECT nvr.id, nvr.name, nvr.app_key, nvr.secret_key, nvr.code, nvr.access_token, nvr.expired_token, nvr.streaming_token, nvr.address, nvr.city, nvr.camera_brand, nvr.contact, nvr.last_update
                      FROM nvr
                      JOIN user_nvr
                      ON nvr.id = user_nvr.nvr_id
                      WHERE status = true AND user_nvr.user_id = '${user_id}'
                      ORDER BY id ASC`

    const rowsDVR = (await pool_db.query(queryDVR)).rows

    const updateTokenIfNeeded = async (nvr) => {
        const { expired_token } = nvr
        const check = checkExpiration(expired_token)

        if (check || !expired_token) {
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
                latitude: mergedCamera.latitude,
                longitude: mergedCamera.longitude,
                url: streamingUrl,
                streamToken: nvr.streaming_token
            }
        })

        const cameraData = await Promise.all(streamingPromises)
        allCameras = allCameras.concat(cameraData)
    }

    return response.json({ error: false, data: allCameras })
}