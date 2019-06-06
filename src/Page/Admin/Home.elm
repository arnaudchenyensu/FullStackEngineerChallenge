module Page.Admin.Home exposing
  (view)

import Employee exposing (Employee)
import Html exposing (Html, div, ul, li, a, text)
import Html.Attributes exposing (href)

viewEmployee : Employee -> Html msg
viewEmployee employee =
  let
    link =
      "admin/" ++ (Employee.idToString (Employee.id employee))
  in
    li
      []
      [ a [ href link ] [ text (Employee.name employee) ] ]

view : List Employee -> Html msg
view employees =
  let
    lis =
      List.map viewEmployee employees
  in
    ul [] lis
