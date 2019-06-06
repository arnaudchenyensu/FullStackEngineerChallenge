module Feedback exposing
  ( Id
  , Feedback
  )

import Employee
import PerfReview

type Id
  = Id String

type Feedback
  = Feedback Id Info

type alias Info =
  { date : String
  , from : Employee.Id
  , text : String
  , submitted : Bool
  , perfReviewId : PerfReview.Id
  }