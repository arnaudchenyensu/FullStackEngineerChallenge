import Api
import Browser
import Browser.Navigation as Nav
import Employee exposing (Employee)
import Html exposing (Html, div, text, ul, li, a)
import Html.Attributes exposing (href)
import Http
import Url exposing (Url)
import Url.Parser as P exposing (Parser, parse, (</>), top, map, oneOf)
import Page.Admin.Home
import Page.Admin.PerfReview.List
import Page.Employee
import Route exposing (Route)


main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }

changeRouteTo : Route -> Model -> (Model, Cmd Msg)
changeRouteTo route model =
  let
    newModel =
      { model | route = route }
  in
    case route of
      Route.Home ->
        (newModel, Cmd.none)
      Route.AdminHome ->
        (newModel, Api.getEmployees GotEmployees)
      Route.AdminPerfReviewList employeeId ->
        (newModel, Cmd.none)
      Route.AdminPerfReviewDetails employeeId perfReviewId ->
        (newModel, Cmd.none)
      Route.EmployeeLogin ->
        (newModel, Cmd.none)
      Route.EmployeeHome s ->
        (newModel, Cmd.none)
      Route.NotFound ->
        (newModel, Cmd.none)

type alias Model =
  { key : Nav.Key
  , route : Route
  , employees : List Employee
  }

init : () -> Url -> Nav.Key -> (Model, Cmd Msg)
init flags url key =
  changeRouteTo
    (Route.fromUrl url)
    { key = key
    , route = Route.fromUrl url
    , employees = []
    }

type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url
  | GotEmployees (Result Http.Error (List Employee))

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
      changeRouteTo (Route.fromUrl url) model
    GotEmployees result ->
      case result of
        Ok employees ->
          ( { model | employees = employees }
          , Cmd.none
          )
        Err err ->
          let
            _ = Debug.log "Error while fetching employees" err
          in
            (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

view : Model -> Browser.Document Msg
view model =
  { title = "URL test"
  , body =
    case model.route of
      Route.Home ->
        [ text ("The current route is: " ++ (Debug.toString model.route))
        , ul
          []
          [ li [] [ a [ href "/" ] [ text "home" ] ]
          , li [] [ a [ href "/admin/employees" ] [ text "admin"] ]
          , li [] [ a [ href "/employee/arnaud" ] [ text "employee" ] ]
          ]
        ]
      Route.AdminHome ->
        [ Page.Admin.Home.view model.employees ]
      Route.AdminPerfReviewList employeeId ->
        [ Page.Admin.PerfReview.List.view (Employee.idFromString employeeId) ]
      Route.AdminPerfReviewDetails employeeId perfReviewId ->
        [ text "adminPerfReviewDetails", text employeeId, text perfReviewId ]
      Route.EmployeeLogin ->
        [ text "employeeLogin" ]
      Route.EmployeeHome e ->
        [ text e ]
      Route.NotFound ->
        [ text "Page not found" ]
  }
