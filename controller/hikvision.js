import axios from 'axios'

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