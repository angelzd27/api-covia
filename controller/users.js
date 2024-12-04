import { pool_db } from "../connection/connection";


// Obtener todos los usuarios
export const getAllUsers = (req, res) => {
    const query = 'SELECT * FROM tbl_users WHERE status = 1';

    pool_db.query(query, (err, results) => {
        if (err) return res.status(500).json({ error: true, msg: err.message });

        res.status(200).json(results);
    });
};

// Obtener un usuario por ID
export const getUserById = (req, res) => {
    const { id } = req.params;
    const query = 'SELECT * FROM tbl_users WHERE id = ? AND status = 1';

    pool_db.query(query, [id], (err, results) => {
        if (err) return res.status(500).json({ error: true, msg: err.message });
        if (results.length === 0) return res.status(404).json({ message: 'User not found' });

        res.status(200).json(results[0]);
    });
};

// Actualizar un usuario
export const updateUser = (req, res) => {
    const { id } = req.params;
    const { first_name, last_name, email, password, phone, profile_id, birthdate } = req.body;

    const fieldsToUpdate = {};
    if (first_name) fieldsToUpdate.first_name = first_name;
    if (last_name) fieldsToUpdate.last_name = last_name;
    if (email) fieldsToUpdate.email = email;
    if (phone) fieldsToUpdate.phone = phone;
    if (profile_id) fieldsToUpdate.profile_id = profile_id;
    if (birthdate) fieldsToUpdate.birthdate = birthdate;

    const updateFields = Object.keys(fieldsToUpdate).map(field => `${field} = ?`).join(', ');
    const updateValues = Object.values(fieldsToUpdate);

    if (password) {
        const saltRounds = 10;
        bcrypt.hash(password, saltRounds, (err, hash) => {
            if (err) return res.status(500).json({ error: true, msg: err.message });

            fieldsToUpdate.password = hash;
            const updateFieldsWithPassword = `${updateFields}, password = ?`;
            const updateValuesWithPassword = [...updateValues, hash];

            const query = `UPDATE tbl_users SET ${updateFieldsWithPassword} WHERE id = ?`;
            pool_db.query(query, [...updateValuesWithPassword, id], (err, result) => {
                if (err) return res.status(500).json({ error: true, msg: err.message });
                if (result.affectedRows === 0) return res.status(404).json({ error: true, msg: 'User not found' });

                res.status(200).json({ error: false, msg: "User updated" });
            });
        });
    } else {
        const query = `UPDATE tbl_users SET ${updateFields} WHERE id = ?`;
        pool_db.query(query, [...updateValues, id], (err, result) => {
            if (err) return res.status(500).json({ error: true, msg: err.message });
            if (result.affectedRows === 0) return res.status(404).json({ error: true, msg: 'User not found' });

            res.status(200).json({ error: false, msg: "User updated" });
        });
    }
};

// Eliminar un usuario
export const deleteUser = (req, res) => {
    const { id } = req.params;
    const query = 'UPDATE tbl_users SET status = 0 WHERE id = ?';

    pool_db.query(query, [id], (err, result) => {
        if (err) return res.status(500).json({ error: true, msg: err.message });
        if (result.affectedRows === 0) return res.status(404).json({ message: 'User not found' });

        res.status(200).json({ message: 'User deleted' });
    });
};
