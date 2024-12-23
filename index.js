import express from 'express';
import cors from 'cors';
import net from 'net';
import http from 'http';
import jwt from 'jsonwebtoken';
import { Server as SocketIOServer } from 'socket.io';
import ioClient from 'socket.io-client';
import dotenv from 'dotenv';
import axios from 'axios';
import { v4 as uuidv4 } from 'uuid';
import { router_hikvision } from './routes/hikvision.js';
import { router_ruptela } from './routes/ruptela.js';
import { router_auth } from './routes/auth.js';
import { router_devices } from './routes/devices.js';
import { router_geofences } from './routes/geofences.js';
import { parseRuptelaPacketWithExtensions } from './controller/ruptela.js';
import { router_drones } from './routes/drones.js';
import { router_users } from './routes/users.js';
import { router_alerts } from './routes/alerts.js';
import { pool_db } from './connection/connection.js';
import { router_reports } from './routes/reports.js';
import { router_admin } from './routes/admin.js';
import { verifyAdmin } from './middleware/verifyAdmin.js'

dotenv.config();
const app = express();
const PORT = 5000;
const TCP_PORT = 6000;
const EXTERNAL_SOCKET_URL = 'http://74.208.169.184:12056';
const JWT_SECRET = process.env.SECRET_KEY;
const USERNAME = process.env.USERAPI;
const PASSWORD = process.env.PASSWORD;

let externalSocket = null;
let teridList = [];
let apiKey = null;

// Configuración de CORS
const corsOptions = {
    origin: 'http://localhost:5173',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    credentials: true,
};

app.use(cors(corsOptions));
app.use(express.json());
app.use('/api/hikvision', router_hikvision);
app.use('/api/ruptela', router_ruptela);
app.use('/api/auth', router_auth);
app.use('/api/devices', router_devices);
app.use('/api/geofences', router_geofences);
app.use('/api/drones', router_drones);
app.use('/api/users', router_users);
app.use('/api/alerts', router_alerts)
app.use('/api/reports', router_reports)
app.use('/api/admin', verifyAdmin, router_admin)

// Crear servidor HTTP unificado
const httpServer = http.createServer(app);

// Configuración de Socket.IO en el mismo servidor HTTP
const io = new SocketIOServer(httpServer, {
    cors: {
        origin: 'http://localhost:5173',
    },
    reconnection: true,
    reconnectionAttempts: Infinity,
    reconnectionDelay: 1000,
});

// Función para obtener API Key y lista de dispositivos
const initializeExternalData = async () => {
    try {
        // Obtener el key de la API
        const apiResponse = await axios.get(
            `${EXTERNAL_SOCKET_URL}/api/v1/basic/key?username=${USERNAME}&password=${PASSWORD}`
        );
        apiKey = apiResponse.data.data.key;

        // Obtener lista de dispositivos
        const devicesResponse = await axios.get(
            `${EXTERNAL_SOCKET_URL}/api/v1/basic/devices?key=${apiKey}`
        );
        teridList = devicesResponse.data.data.map((device) => device.terid);
        console.log('TERID list initialized:', teridList);
    } catch (error) {
        console.error('Error al inicializar datos externos:', error.message);
    }
};

// Conectar al socket externo y manejar eventos
const connectToExternalSocket = () => {
    externalSocket = ioClient(EXTERNAL_SOCKET_URL, {
        transports: ['websocket'],
        reconnection: true,
        reconnectionAttempts: Infinity,
        reconnectionDelay: 1000,
    });

    externalSocket.on('connect', () => {
        console.log('Conectado al socket externo');
        externalSocket.emit('sub_gps', { key: apiKey, didArray: teridList });
        externalSocket.emit('sub_alarm', {
            key: apiKey,
            didArray: teridList,
            alarmType: [1, 3, 13, 18, 19, 20, 29, 36, 38, 47, 58, 60, 61, 62, 63, 64, 74, 160, 162, 163, 164, 169, 392],
        });
    });

    externalSocket.on('sub_gps', (data) => {
        const room = `device-${data.deviceno}`;
        io.to(room).emit('sub_gps', data);

        if (data.speed > 5) {
            const insertUserQuery = `
            INSERT INTO public.routes(id, device_id, latitude, longitude, date, speed)
	        VALUES ($1, $2, $3, $4, $5, $6)
            RETURNING *;
            `;
            const userValues = [uuidv4(), data.deviceno, data.lat, data.lng, data.dateTime, data.speed];
            pool_db.query(insertUserQuery, userValues);
        }
    });

    externalSocket.on('sub_alarm', (data) => {
        const room = `device-${data.deviceno}`;
        io.to(room).emit('sub_alarm', data);

        if (data.alarmId != null) {
            const insertUserQuery = `
            INSERT INTO public.alerts(
	        id, device_id, alert_id, latitude, longitude, date)
	        VALUES ($1, $2, $3, $4, $5, $6)
            RETURNING *;
        `;
            const userValues = [data.alarmId, data.deviceno, data.type, data.lat, data.lng, data.dateTime];
            pool_db.query(insertUserQuery, userValues);
        }
    });

    externalSocket.on('error', (err) => {
        console.error('Error en el socket externo:', err.message);
    });

    externalSocket.on('disconnect', (reason) => {
        console.log(`Socket externo desconectado: ${reason}`);
    });
};

// Manejo de conexión de clientes al socket intermedio
io.on('connection', (socket) => {
    console.log('Cliente conectado al socket intermedio');

    socket.on('connect-to-external', ({ token, didArray }) => {
        try {
            // Validar token
            const decoded = jwt.verify(token, JWT_SECRET);
            const userDevices = didArray;

            // Unir al cliente a rooms basados en sus dispositivos
            userDevices.forEach((device) => {
                const room = `device-${device}`;
                socket.join(room);
            });
        } catch (error) {
            console.error('Error al conectar al socket externo:', error.message);
            socket.emit('connection-error', { message: 'Token inválido' });
        }
    });

    socket.on('disconnect', () => {
        console.log('Cliente desconectado');
    });
});

// Inicializar datos externos y arrancar servidores
httpServer.listen(PORT, async () => {
    console.log(`Servidor HTTP y Socket.IO escuchando en el puerto ${PORT}`);
    await initializeExternalData();
    connectToExternalSocket();
});

// Configuración del servidor TCP
const tcpServer = net.createServer((socket) => {
    console.log('GPS connected via TCP');

    socket.on('data', (data) => {
        try {
            const hexData = data.toString('hex');
            const decodedData = parseRuptelaPacketWithExtensions(hexData);

            // Emitir datos decodificados al cliente conectado vía Socket.IO
            io.emit('gps-data', decodedData);
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
    console.log(`Servidor TCP escuchando en el puerto ${TCP_PORT}`);
});

// Manejo global de errores para garantizar disponibilidad
process.on('uncaughtException', (err) => {
    console.error('Excepción no capturada:', err.message);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('Promesa rechazada sin manejar:', promise, 'Razón:', reason);
});