export const checkExpiration = (timestamp) => {
    const expDate = new Date(timestamp * 1000)
    const currentDate = new Date()
    return expDate < currentDate
}