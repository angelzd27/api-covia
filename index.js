import express from 'express'
import cors from 'cors'
import net from 'net'
import http from 'http';
import { router_hikvision } from './routes/hikvision.js'
import { router_ruptela } from './routes/ruptela.js'
import { router_auth } from './routes/auth.js'
import { router_devices } from './routes/devices.js'
import { router_geofences } from './routes/geofences.js'
import { parseRuptelaPacketWithExtensions } from './controller/ruptela.js'
import { Server as SocketIOServer } from 'socket.io';

const app = express()
const PORT = 5000 || 1500
const TCP_PORT = 6000
const SOCKET_PORT = 4000;

// Cnfiguración de CORS
const corsOptions = {
    origin: 'http://localhost:5173', // Reemplaza con el dominio de tu frontend
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

app.listen(PORT, () => {
    console.log(`La marrana HTTP esta viva en el puerto ${PORT}`)
})

// Configuración del servidor TCP
const tcpServer = net.createServer((socket) => {
    console.log('GPS connected via TCP');

    socket.on('data', (data) => {
        try {
            const hexData = data.toString('hex');
            const decodedData = parseRuptelaPacketWithExtensions(hexData);

            // Emitir datos decodificados al cliente conectado vía socket.io
            io.emit('gps-data', decodedData);
            console.log('Data received and emitted:', decodedData);
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

// Configuración del servidor HTTP y socket.io
const httpServer = http.createServer();
const io = new SocketIOServer(httpServer, {
    cors: {
        origin: '*',
    },
});

tcpServer.listen(TCP_PORT, () => {
    console.log(`TCP server listening on port ${TCP_PORT}`);
});

httpServer.listen(SOCKET_PORT, () => {
    console.log(`Socket.IO server listening on port ${SOCKET_PORT}`);
});

// Manejo de eventos de socket.io
io.on('connection', (socket) => {
    console.log('Client connected via Socket.IO');

    socket.on('disconnect', () => {
        console.log('Client disconnected');
    });
});