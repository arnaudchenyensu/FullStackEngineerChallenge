const express = require('express')
const history = require('connect-history-api-fallback');
const knex = require('knex')({
  client: 'sqlite3',
  connection: {
    filename: './build/app.db'
  }
});

const app = express();
app.use(history({
  rewrites: [
    { from: /^\/api\/.*$/,
      to: function(context) {
        return context.parsedUrl.pathname;
      }
    }
  ]
}));
app.use(express.static('build'));

const port = 3000

app.listen(port, () => {
  console.log(`App listening on port ${port}!`)
});

app.get('/api/employees', (req, res) => {
  knex
    .select()
    .from('employee')
    .then((rows) => {
      res.send(rows);
    })
    .catch((err) => {
      console.error(err);
    });
});

app.get('/api/perfReviews', (req, res) => {
  knex
    .select()
    .from('perfReview')
    .then((rows) => {
      res.send(rows);
    })
    .catch((err) => {
      console.error(err);
    });
});

app.get('/api/feedbacks', (req, res) => {
  knex
    .select()
    .from('feedback')
    .then((rows) => {
      res.send(rows);
    })
    .catch((err) => {
      console.error(err);
    });
});
