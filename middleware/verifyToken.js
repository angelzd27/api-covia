import jwt from 'jsonwebtoken'

export const verifyToken = async (request, response, next) => {
    const { authorization } = request.headers

    if (!authorization)
        return response.status(401).json({ error: true, data: 'auth_token_not_provider' })

    try {
        const decoded = jwt.verify(authorization, process.env.SECRET_KEY)
        next()
    } catch (err) {
        return response.status(400).json({ error: true, data: 'jwt_malformed' })
    }
}