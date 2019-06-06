module Page.Admin.PerfReview.List exposing
  (view)

import Api
import Employee
import Html exposing (Html, h2, div, p, text)
import PerfReview exposing (PerfReview)

viewPerfReview : PerfReview -> Html msg
viewPerfReview perfReview =
  let
    info =
      PerfReview.info perfReview
  in
    div
      []
      [ p [] [ text info.date ]
      , p [] [ text info.text ]
      ]

view : Employee.Id -> Html msg
view id =
  let
    perfReviews =
      Api.getPerfReviews id
  in
    div
      []
      (List.map viewPerfReview perfReviews)
