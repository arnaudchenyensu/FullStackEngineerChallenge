module Employee exposing
  ( Employee
  , Id
  , id
  , idToString
  , idFromString
  , new
  , name
  )

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

name : Employee -> String
name (Employee _ name_) =
  name_
