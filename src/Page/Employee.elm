module Page.Employee exposing
  ( view )

import Html exposing (Html, div, text)

view : String -> Html msg
view employee =
  div
    []
    [ text "Employee name: "
    , text employee
    ]
