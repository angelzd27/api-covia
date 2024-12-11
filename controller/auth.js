import bcrypt from 'bcrypt';
import { v4 as uuidv4 } from 'uuid';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
import { pool_db } from '../connection/connection.js';
import axios from 'axios';

dotenv.config();
const JWT_SECRET = process.env.SECRET_KEY;
const USERNAME = process.env.USERAPI;
const PASSWORD = process.env.PASSWORD;

//login
export const loginUser = async (req, res) => {
    const { email, password } = req.body;

    // Validar que los campos requeridos estén presentes
    if (!email || !password) {
        return res.status(400).json({ error: 'Correo y contraseña son obligatorios.' });
    }

    try {
        // Buscar usuario por correo
        const query = `SELECT id, first_name, password, birthdate FROM users WHERE email = $1`;
        const values = [email];
        const result = await pool_db.query(query, values);

        // Verificar si el usuario existe
        if (result.rows.length === 0) {
            return res.status(401).json({ error: true, msg: 'Invalid credentials.' });
        }

        const user = result.rows[0];

        // Comparar la contraseña encriptada
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(401).json({ error: true, msg: 'Invalid credentials.' });
        }

        const apiResponse = await axios.get(`http://74.208.169.184:12056/api/v1/basic/key?username=${USERNAME}&password=${PASSWORD}`)
        const key = apiResponse.data.data.key

        // Crear el JWT
        const token = jwt.sign(
            { id: user.id, user: user.first_name, birthdate: user.birthdate, key },
            JWT_SECRET,
            { expiresIn: '12h' }
        );

        // Enviar el token al cliente
        res.status(200).json({ error: false, msg: token });
    } catch (error) {
        console.error('Error en el login:', error);
        res.status(500).json({ error: 'Error en el servidor.' });
    }
};

// register
export const createUser = async (req, res) => {
    const { first_name, last_name, email, password, phone, birthdate, profile_ids } = req.body;

    // Validar que los campos requeridos estén presentes
    if (!first_name || !last_name || !email || !password || !phone || !birthdate || !Array.isArray(profile_ids)) {
        return res.status(400).json({ error: true, msg: 'All fields, including profile_ids, are required.' });
    }

    const client = await pool_db.connect();

    try {
        // Iniciar la transacción
        await client.query('BEGIN');

        // Generar UUID para el usuario
        const userId = uuidv4();

        // Encriptar la contraseña
        const hashedPassword = await bcrypt.hash(password, 10);

        // Insertar usuario en la tabla `users`
        const insertUserQuery = `
            INSERT INTO users (id, first_name, last_name, email, password, phone, birthdate)
            VALUES ($1, $2, $3, $4, $5, $6, $7)
            RETURNING *;
        `;
        const userValues = [userId, first_name, last_name, email, hashedPassword, phone, birthdate];
        const userResult = await client.query(insertUserQuery, userValues);

        // Insertar relaciones en la tabla `user_profile`
        const insertUserProfileQuery = `
            INSERT INTO user_profile (user_id, profile_id)
            VALUES ($1, $2);
        `;

        for (const profileId of profile_ids) {
            await client.query(insertUserProfileQuery, [userId, profileId]);
        }

        // Confirmar la transacción
        await client.query('COMMIT');

        // Obtener los perfiles del usuario
        const getUserProfilesQuery = `
        SELECT p.id, p.profile
        FROM profiles p
        INNER JOIN user_profile up ON p.id = up.profile_id
        WHERE up.user_id = $1;
    `;
        const profilesResult = await client.query(getUserProfilesQuery, [userId]);

        const userData = {
            id: userResult.rows[0].id,
            first_name: userResult.rows[0].first_name,
            last_name: userResult.rows[0].last_name,
            email: userResult.rows[0].email,
            password: userResult.rows[0].password,
            phone: userResult.rows[0].phone,
            birthdate: userResult.rows[0].birthdate,
            status: true,
            profiles: profilesResult.rows
        };

        return res.status(201).json({
            error: false,
            data: userData
        });
    } catch (error) {
        // Revertir la transacción en caso de error
        await client.query('ROLLBACK');
        console.error('Error al crear el usuario con perfiles:', error);
        res.status(500).json({ error: true, msg: 'Error al crear el usuario con perfiles.' });
    } finally {
        // Liberar el cliente
        client.release();
    }
};