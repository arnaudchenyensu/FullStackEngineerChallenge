const express = require('express')
const history = require('connect-history-api-fallback');

const app = express()
app.use(history())
app.use(express.static('build'))

const port = 3000

app.listen(port, () => {
  console.log(`App listening on port ${port}!`)
})
