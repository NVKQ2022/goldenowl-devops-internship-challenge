const { Router } = require('express')

const router = Router()

router.get('/', (req, res) => {
    const responseJson = {
        message: 'Welcome warriors to Golden Owl!v1.0.2',
    }
    res.json(responseJson)
})

module.exports = router
