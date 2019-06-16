const express = require('express');
const cors = require('cors');
const history = require('connect-history-api-fallback');
const knex = require('knex')({
  client: 'sqlite3',
  connection: {
    filename: './api/app.db'
  }
});

const app = express();
app.use(cors());
app.use(express.json());

// to serve html,
// except if the url starts with /api
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

// list employees
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

// get specific employee
app.get('/api/employees/:employeeId', (req, res) => {
  knex
    .select()
    .from('employee')
    .where({ id: req.params.employeeId })
    .then((rows) => {
      res.send(rows);
    })
    .catch((err) => {
      console.error(err);
    });
});

// create new employee
app.post('/api/employees', (req, res) => {
  knex
    .insert(req.body)
    .into('employee')
    .then((ids) => {
      return knex
        .select()
        .from('employee')
        .where({ id: ids[0] })
    })
    .then((rows) => {
      res.send(rows);
    })
    .catch((err) => {
      console.error(err);
      res.sendStatus(500);
    })
});

// update employee
app.post('/api/employees/:employeeId', (req, res) => {
  knex('employee')
    .update(req.body)
    .where({ id: req.params.employeeId })
    .then(() => {
      return knex
        .select()
        .from('employee')
        .where({ id: req.params.employeeId })
    })
    .then((rows) => {
      res.send(rows);
    })
    .catch((err) => {
      console.error(err);
      res.sendStatus(500);
    })
});

// delete employee
app.post('/api/employees/:employeeId/delete', (req, res) => {
  knex('employee')
    .delete()
    .where({ id: req.params.employeeId })
    .then(() => {
      res.send();
    })
    .catch((err) => {
      console.error(err);
    })
})

// get perfReviews of a specific employee
app.get('/api/employees/:employeeId/perfReviews', (req, res) => {
  knex
    .select()
    .from('perfReview')
    .where({ employeeId: req.params.employeeId })
    .then((rows) => {
      res.send(rows);
    })
    .catch((err) => {
      console.error(err);
    });
});

// get feedbacks of a specific employee
app.get('/api/employees/:employeeId/feedbacks', (req, res) => {
  knex
    .select(
      'feedback.*',
      'perfReview.employeeId as perfReview_employeeId',
      'perfReview.text as perfReview_text'
    )
    .from('feedback')
    .where({ from: req.params.employeeId })
    .innerJoin('perfReview', 'feedback.perfReviewId', 'perfReview.id')
    .then((rows) => {
      res.send(rows);
    })
    .catch((err) => {
      console.error(err);
    });
});

// list perfReviews
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

// create new perfReview
app.post('/api/perfReviews', (req, res) => {
  knex
    .insert(req.body)
    .into('perfReview')
    .then((ids) => {
      return knex
        .select()
        .from('perfReview')
        .where({ id: ids[0] })
    })
    .then((rows) => {
      res.send(rows);
    })
    .catch((err) => {
      console.error(err);
      res.sendStatus(500);
    })
});

// get specific perfReview
app.get('/api/perfReviews/:perfReviewId', (req, res) => {
  knex
    .select()
    .from('perfReview')
    .where({ id: req.params.perfReviewId })
    .then((rows) => {
      res.send(rows);
    })
    .catch((err) => {
      console.error(err);
    });
});

// update specific perfReview
app.post('/api/perfReviews/:perfReviewId', (req, res) => {
  knex('perfReview')
    .update(req.body)
    .where({ id: req.params.perfReviewId })
    .then(() => {
      res.send([req.params.perfReviewId]);
    })
    .catch((err) => {
      console.error(err);
      res.sendStatus(500);
    })
});

// get feedbacks of a specific perfReview
app.get('/api/perfReviews/:perfReviewId/feedbacks', (req, res) => {
  knex
    .select(
      'feedback.*',
      'employee.id as employee_id',
      'employee.name as employee_name'
    )
    .from('feedback')
    .where({ perfReviewId: req.params.perfReviewId })
    .innerJoin('employee', 'feedback.from', 'employee.id')
    .then((rows) => {
      res.send(rows);
    })
    .catch((err) => {
      console.error(err);
    });
});

// list feedbacks
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

// create new feedback
app.post('/api/feedbacks', (req, res) => {
  knex
    .insert(req.body)
    .into('feedback')
    .then((ids) => {
      return knex
        .select(
          'feedback.*',
          'employee.id as employee_id',
          'employee.name as employee_name'
        )
        .from('feedback')
        .where({ 'feedback.id': ids[0] })
        .innerJoin('employee', 'feedback.from', 'employee.id')
    })
    .then((rows) => {
      res.send(rows);
    })
    .catch((err) => {
      console.error(err);
      res.sendStatus(500);
    })
});

// update specific feedback
app.post('/api/feedbacks/:feedbackId', (req, res) => {
  knex('feedback')
    .update(req.body)
    .where({ id: req.params.feedbackId })
    .then(() => {
      res.send([req.params.feedbackId]);
    })
    .catch((err) => {
      console.error(err);
      res.sendStatus(500);
    })
});
