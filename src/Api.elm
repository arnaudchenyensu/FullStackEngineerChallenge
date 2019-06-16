module Api exposing
  ( getEmployees
  , getPerfReviews
  )

import Http
import Json.Decode as Decode
import Employee exposing (Employee)
import PerfReview exposing (PerfReview)

getEmployees : (Result Http.Error (List Employee) -> msg) -> Cmd msg
getEmployees msg =
  Http.get
    { url = "http://localhost:3000/api/employees"
    , expect = Http.expectJson msg (Decode.list Employee.decoder)
    }

getPerfReviews : Employee.Id -> List PerfReview
getPerfReviews employeeId =
  [ PerfReview.new employeeId "Very good month. Lot of improvements."
  , PerfReview.new employeeId "First good month."
  ]
