import Api
import Browser
import Browser.Navigation as Nav
import Employee
import Html exposing (Html, div, text, ul, li, a)
import Html.Attributes exposing (href)
import Url exposing (Url)
import Url.Parser as P exposing (Parser, parse, (</>), top, map, oneOf)
import Page.Admin.Home
import Page.Admin.PerfReview.List
import Page.Employee

main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }

type Route
  = Home
  | Admin
  | AdminPerfReviewList String
  | Employee String
  | NotFound

{-| Routes

Home "/"
Employee "/employee/{id}"
Admin "/admin"
AdminPerfReviewList "/admin/{employeeId}"
-}
route : Parser (Route -> a) a
route =
  oneOf
    [ map Home top
    , map Employee (P.s "employee" </> P.string)
    , map Admin (P.s "admin")
    , map AdminPerfReviewList (P.s "admin" </> P.string)
    ]

toRoute : String -> Route
toRoute string =
  case Url.fromString string of
    Nothing ->
      NotFound
    Just url ->
      Maybe.withDefault NotFound (parse route url)

type alias Model =
  { key : Nav.Key
  , route : Route
  }

init : () -> Url -> Nav.Key -> (Model, Cmd Msg)
init flags url key =
  (Model key (toRoute (Url.toString url)), Cmd.none)

type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          (model, Nav.pushUrl model.key (Url.toString url))
        Browser.External href ->
          (model, Nav.load href)
    UrlChanged url ->
      ( { model | route = toRoute (Url.toString url) }
      , Cmd.none
      )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

view : Model -> Browser.Document Msg
view model =
  { title = "URL test"
  , body =
    case model.route of
      Home ->
        [ text ("The current route is: " ++ (Debug.toString model.route))
        , ul
          []
          [ li [] [ a [ href "/" ] [ text "home" ] ]
          , li [] [ a [ href "/admin" ] [ text "admin"] ]
          , li [] [ a [ href "/employee/arnaud" ] [ text "employee" ] ]
          ]
        ]
      Admin ->
        [ Page.Admin.Home.view Api.getEmployees ]
      AdminPerfReviewList employeeId ->
        [ Page.Admin.PerfReview.List.view (Employee.idFromString employeeId) ]
      Employee e ->
        [ text e ]
      NotFound ->
        [ text "Page not found" ]
  }
