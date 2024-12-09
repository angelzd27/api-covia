import express from 'express'
import cors from 'cors'
import net from 'net'
import { router_hikvision } from './routes/hikvision.js'
import { router_ruptela } from './routes/ruptela.js'
import { router_auth } from './routes/auth.js'
import { router_devices } from './routes/devices.js'
import { router_geofences } from './routes/geofences.js'
import { parseRuptelaPacketWithExtensions } from './controller/ruptela.js'
import { router_drones } from './routes/drones.js'
import SocketServer from './connection/config.js';

const app = express()
const PORT = 5000 || 1500
const TCP_PORT = 6000
const server = SocketServer.instance

// Cnfiguración de CORS
const corsOptions = {
    origin: 'http://localhost:5173',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    credentials: true
}

app.use(cors(corsOptions))
app.use(express.json())
app.use('/api/hikvision', router_hikvision)
app.use('/api/ruptela', router_ruptela)
app.use('/api/auth', router_auth)
app.use('/api/devices', router_devices)
app.use('/api/geofences', router_geofences)
app.use('/api/drones', router_drones)

app.listen(PORT, () => {
    console.log(`La marrana esta viva en el puerto ${PORT}`)
})

// Configuración del servidor TCP
const tcpServer = net.createServer((socket) => {
    console.log('GPS connected via TCP');

    socket.on('data', (data) => {
        try {
            const hexData = data.toString('hex');
            const decodedData = parseRuptelaPacketWithExtensions(hexData);

            // Emitir datos decodificados al cliente conectado vía socket.io
            server.io.emit('gps-data', decodedData)
            console.log('Data received and emitted:', hexData);
        } catch (error) {
            console.error('Error decoding GPS data:', error.message);
        }
    });

    socket.on('end', () => {
        console.log('GPS disconnected');
    });

    socket.on('error', (error) => {
        console.error('TCP socket error:', error.message);
    });
});

tcpServer.listen(TCP_PORT, () => {
    console.log(`TCP server listening on port ${TCP_PORT}`);
});

server.start(() => {
    console.log(`Socket corriendo en el puerto ${server.port}`)
})