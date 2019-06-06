module PerfReview exposing
  ( Id
  , PerfReview
  , new
  , info
  )

import Employee

type Id
  = Id String

type PerfReview
  = PerfReview Id Info

type alias Info =
  { date : String
  , text : String
  , employeeId : Employee.Id
  }

new : Employee.Id -> String -> PerfReview
new employeeId text =
  let
    id_ =
      Id ((Employee.idToString employeeId) ++ text)
    info_ =
      { date = "today"
      , text = text
      , employeeId = employeeId
      }
  in
    PerfReview id_ info_

id : PerfReview -> Id
id (PerfReview id_ _) =
  id_

info : PerfReview -> Info
info (PerfReview _ info_) =
  info_