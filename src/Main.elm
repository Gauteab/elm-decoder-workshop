module Main exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| Decode the sum of the x and y components

    import Json.Decode exposing (decodeString)

    decodeString sumDecoder """{"x":1,"y":2}"""
    --> Ok 3

    decodeString sumDecoder """{"x":12,"y":3}"""
    --> Ok 15

-}
sumDecoder : Decoder Int
sumDecoder =
    Decode.fail "TODO: Decoder not yet implemented"
