const knex = require('knex')({
  client: 'sqlite3',
  connection: {
    filename: './build/app.db'
  }
});

const employees = [
  { name: 'John' },
  { name: 'Frank' }
];

const perfReviews = [
  {
    text: "Good month!",
    employeeId: 1
  },
  {
    text: "Nice improvement!",
    employeeId: 1
  },
  {
    text: "Good month!",
    employeeId: 2
  }
];

const feedbacks = [
  {
    text: "I agree, you did a great work.",
    submitted: true,
    from: 1,
    perfReviewId: 1
  },
  {
    text: "Was a pleasure helping you this month.",
    submitted: true,
    from: 1,
    perfReviewId: 1
  },
  {
    text: "I agree, you did a great work.",
    submitted: true,
    from: 2,
    perfReviewId: 2
  },
];

knex.schema
  .dropTableIfExists('employee')
  .dropTableIfExists('perfReview')
  .dropTableIfExists('feedback')
  .createTable('employee', function (table) {
    table.increments();
    table.string('name');
  })
  .createTable('perfReview', function (table) {
    table.increments();
    table.text('text');
    table.timestamp('date').defaultTo(knex.fn.now());
    table.integer('employeeId');
    table.foreign('employeeId').references('employee.id');
  })
  .createTable('feedback', function (table) {
    table.increments();
    table.timestamp('date').defaultTo(knex.fn.now());
    table.text('text');
    table.boolean('submitted');
    table.integer('from');
    table.foreign('from').references('employee.id');
    table.integer('perfReviewId');
    table.foreign('perfReviewId').references('perfReview.id');
  })
  .then(() => knex.insert(employees).into('employee'))
  .then(() => knex.insert(perfReviews).into('perfReview'))
  .then(() => knex.insert(feedbacks).into('feedback'))
  .then(function () {
    console.log('success');
  })
  .catch(function (error) {
    console.error(error);
  })
