module VerifyExamples.Main.SumDecoder3 exposing (..)

-- This file got generated by [elm-verify-examples](https://github.com/stoeffel/elm-verify-examples).
-- Please don't modify this file by hand!

import Test
import Expect

import Main exposing (..)
import Json.Decode exposing (decodeString)







spec3 : Test.Test
spec3 =
    Test.test "#sumDecoder: \n\n    decodeString sumDecoder \"\"\"{\"x\":12,\"y\":3}\"\"\"\n    --> Ok 15" <|
        \() ->
            Expect.equal
                (
                decodeString sumDecoder """{"x":12,"y":3}"""
                )
                (
                Ok 15
                )