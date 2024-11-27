let coordinates = { latitude: null, longitude: null }

export const getCoordinates = async (request, response) => {
    response.json(coordinates)
}

export const gpsData = async (request, response) => {
    if (datos) {
        res.json({ data: datos.toString('hex') }) // Devuelve los datos en formato hexadecimal
    } else {
        res.status(404).json({ error: 'No se han recibido datos de GPS.' })
    }
}

export const setCoordinates = async (request, response) => {
    const { latitude, longitude } = req.body
    coordinates = { latitude, longitude }
    res.json({ message: 'Coordenadas guardadas correctamente', coordinates })
}