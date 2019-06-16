module Employee exposing
  ( Employee
  , Id
  , id
  , idToString
  , idFromString
  , decoder
  , new
  , name
  )


import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)

type Id
  = Id String

type Employee
  = Employee Id String

new : String -> Employee
new name_ =
  Employee (Id name_) name_

id : Employee -> Id
id (Employee id_ _) =
  id_

idToString : Id -> String
idToString (Id id_) =
  id_

-- this function will be remove
-- once the backend works
idFromString : String -> Id
idFromString string =
  Id string

idDecoder : Decoder Id
idDecoder =
  Decode.map Id (Decode.map String.fromInt Decode.int)

name : Employee -> String
name (Employee _ name_) =
  name_

decoder : Decoder Employee
decoder =
  Decode.succeed Employee
  |> required "id" idDecoder
  |> required "name" Decode.string
