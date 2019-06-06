module Api exposing
  ( getEmployees
  , getPerfReviews
  )

import Employee exposing (Employee)
import PerfReview exposing (PerfReview)

getEmployees : List Employee
getEmployees =
  [ Employee.new "Fred"
  , Employee.new "John"
  ]

getPerfReviews : Employee.Id -> List PerfReview
getPerfReviews employeeId =
  [ PerfReview.new employeeId "Very good month. Lot of improvements."
  , PerfReview.new employeeId "First good month."
  ]