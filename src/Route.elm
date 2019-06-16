module Route exposing
  ( Route(..)
  , fromUrl
  )


import Url exposing (Url)
import Url.Parser as P exposing (Parser, parse, (</>), top, map, oneOf)


type Route
  = Home
  | AdminHome
  | AdminPerfReviewList String
  | AdminPerfReviewDetails String String
  | EmployeeLogin
  | EmployeeHome String
  | NotFound

{-| Routes

Home "/"

AdminHome "/admin/employees"
AdminPerfReviewList "/admin/employees/:employeeId/perfReviews"
AdminPerfReviewDetails "/admin/employees/:employeeId/perfReviews/:perfReviewId"

EmployeeLogin "/employee/login"
EmployeeHome "/employee/login/:employeeId"
-}
parser : Parser (Route -> a) a
parser =
  oneOf
    [ map Home top
    -- Admin view
    , map AdminHome (P.s "admin" </> P.s "employees")
    , map AdminPerfReviewList (P.s "admin" </> P.s "employees" </> P.string </> P.s "perfReviews")
    , map AdminPerfReviewDetails (P.s "admin" </> P.s "employees" </> P.string </> P.s "perfReviews" </> P.string)
    -- Employee view
    , map EmployeeLogin (P.s "employee" </> P.s "login")
    , map EmployeeHome (P.s "employee" </> P.s "login" </> P.string)
    ]

fromUrl : Url -> Route
fromUrl url =
  Maybe.withDefault NotFound (parse parser url)
