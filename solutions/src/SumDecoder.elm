module SumDecoder exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| Decode the sum of the x and y components

    npm run sum

    import Json.Decode exposing (decodeString)

    decodeString sumDecoder """{"x":1,"y":2}"""
    --> Ok 3

    decodeString sumDecoder """{"x":12,"y":3}"""
    --> Ok 15

-}
sumDecoder : Decoder Int
sumDecoder =
    Decode.map2 (\x y -> x + y)
        (Decode.field "x" Decode.int)
        (Decode.field "y" Decode.int)
