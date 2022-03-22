module PersonDecoder exposing (..)

import Json.Decode as Decode exposing (Decoder, andThen, bool, field, int, maybe, oneOf, string)
import Json.Decode.Pipeline exposing (custom, hardcoded, optional, required)


type alias Person =
    { name : String
    , age : Int
    }


{-| Decode a Person

    npm run person

    import PersonDecoder exposing (Person)
    import Json.Decode exposing (decodeString)

    decodeString personDecoder """{ "name": "Tom", "age": 42 }"""
    --> Ok (Person "Tom" 42)

-}
personDecoder : Decoder Person
personDecoder =
    Decode.succeed Person
        |> required "name" string
        |> required "age" int



---------------------------------------------------------


type alias PersonWithPhone =
    { name : String
    , age : Int
    , phone : Int
    }


{-| Decode a PersonWithPhone

    npm run person-with-phone

    import PersonDecoder exposing (PersonWithPhone)
    import Json.Decode exposing (decodeString)

    decodeString personWithPhoneDecoder """{ "name": "Tom", "age": 42, "phone": 99112233 }"""
    --> Ok (PersonWithPhone "Tom" 42 99112233)

-}
personWithPhoneDecoder : Decoder PersonWithPhone
personWithPhoneDecoder =
    Decode.succeed PersonWithPhone
        |> required "name" string
        |> required "age" int
        |> required "phone" int



---------------------------------------------------------


type alias PersonWithMaybePhone =
    { name : String
    , age : Int
    , phone : Maybe String
    }


{-| Decode a PersonWithMaybePhone

    npm run person-with-maybe-phone
    Note: phone field changed from Int to Maybe String

    import PersonDecoder exposing (PersonWithMaybePhone)
    import Json.Decode exposing (decodeString)

    decodeString personWithMaybePhoneDecoder """{ "name": "Tom", "age": 42, "phone": "99112233" }"""
    --> Ok (PersonWithMaybePhone "Tom" 42 (Just "99112233")) -- can decode valid example

    decodeString personWithMaybePhoneDecoder """{ "name": "Tom", "age": 42 }"""
    --> Ok (PersonWithMaybePhone "Tom" 42 Nothing) -- phone-field can be missing

    decodeString personWithMaybePhoneDecoder """{ "name": "Tom", "age": 42, "phone": null }"""
    --> Ok (PersonWithMaybePhone "Tom" 42 Nothing) -- phone-field can be null

-}
personWithMaybePhoneDecoder : Decoder PersonWithMaybePhone
personWithMaybePhoneDecoder =
    Decode.succeed PersonWithMaybePhone
        |> required "name" string
        |> required "age" int
        |> optional "phone" (maybe string) Nothing



---------------------------------------------------------


type alias PersonWithAddress =
    { name : String
    , age : Int
    , phone : Maybe String
    , address : Address
    }


type alias Address =
    { zipCode : String
    , street : String
    , houseNumber : Int
    }


{-| Decode a PersonWithAddress

    npm run person-with-address

    import PersonDecoder exposing (PersonWithAddress)
    import Json.Decode exposing (decodeString)

    decodeString personWithAddressDecoder """
        {
            "name": "Tom",
            "age": 42,
            "phone": "99112233",
            "address": {
                "zipCode": "2012",
                "street": "Elm Street",
                "houseNumber": 13
            }
        }
        """
    --> Ok (PersonWithAddress "Tom" 42 (Just "99112233") (Address "2012" "Elm Street" 13) )

-}
personWithAddressDecoder : Decoder PersonWithAddress
personWithAddressDecoder =
    Decode.succeed PersonWithAddress
        |> required "name" string
        |> required "age" int
        |> required "phone" (maybe string)
        |> required "address" addressDecoder


addressDecoder : Decoder Address
addressDecoder =
    Decode.succeed Address
        |> required "zipCode" string
        |> required "street" string
        |> required "houseNumber" int



---------------------------------------------------------


type alias Employee =
    { fullName : String
    , role : Role
    }


type Role
    = Internal
    | External String
    | SummerStudent


{-| Decode an Employee

    npm run person-employee

    import PersonDecoder exposing (Employee)
    import Json.Decode exposing (decodeString)

    decodeString employeeDecoder """{"firstName":"Tom","lastName":"Thomson","summerStudent":false,"company":"Sopra Steria"}"""
    --> Ok (Employee "Tom Thomson" (External "Sopra Steria"))

    decodeString employeeDecoder """{"firstName":"Tom","lastName":"Thomson","summerStudent":false}"""
    --> Ok (Employee "Tom Thomson" Internal)

-}
employeeDecoder : Decoder Employee
employeeDecoder =
    Decode.succeed Employee
        |> custom nameDecoder
        |> custom roleDecoder


nameDecoder : Decoder String
nameDecoder =
    Decode.map2 (\first last -> first ++ " " ++ last)
        (field "firstName" string)
        (field "lastName" string)


type alias JsonData =
    { isSummerStudent : Bool, company : Maybe String }


roleDecoder : Decoder Role
roleDecoder =
    Decode.succeed JsonData
        |> required "summerStudent" bool
        |> optional "company" (Decode.nullable string) Nothing
        |> Decode.map
            (\{ isSummerStudent, company } ->
                if isSummerStudent then
                    SummerStudent

                else
                    company
                        |> Maybe.map External
                        |> Maybe.withDefault Internal
            )
