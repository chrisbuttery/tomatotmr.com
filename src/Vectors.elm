module Vectors exposing (close, pause, reset, settings, start, tomato)

import Svg.Styled exposing (..)
import Svg.Styled.Attributes exposing (..)


settings w h =
    svg
        [ width w
        , height h
        , viewBox "0 0 84 85"
        , class "db"
        ]
        [ Svg.Styled.path
            [ fill "#000"
            , fillOpacity "0.6"
            , fillRule "evenodd"
            , d "M42 61a18 18 0 1 1 0-37 18 18 0 0 1 0 37zm34-19c0-5 3-9 8-12l-3-8c-6 1-10-1-14-4-4-4-5-9-3-14l-9-4c-3 5-8 9-13 9S32 5 29 0l-9 4c2 5 1 10-3 14-4 3-8 5-14 4l-3 8c5 3 8 7 8 12 0 6-3 11-8 14l3 8c6-1 10 0 14 3 4 4 5 9 3 14l9 3c3-4 8-8 13-8s10 4 13 8l9-3c-2-5-1-10 3-14 4-3 8-5 14-4l3-8c-5-3-8-7-8-13z"
            ]
            []
        ]


close w h =
    svg
        [ width w
        , height h
        , viewBox "0 0 48 53"
        , class "db"
        ]
        [ Svg.Styled.path
            [ fill "#fff"
            , fillRule "evenodd"
            , d "M46 42L32 26l14-15a6 6 0 0 0-9-9L24 17 11 2a6 6 0 0 0-9 9l14 15L2 42a6 6 0 0 0 9 9l13-15 13 15a6 6 0 0 0 9-9"
            ]
            []
        ]


start w h =
    svg
        [ width w
        , height h
        , viewBox "0 0 50 61"
        , class "db"
        ]
        [ Svg.Styled.path
            [ fill "#000"
            , fillOpacity "0.6"
            , fillRule "evenodd"
            , d "M48 28L6 1C3-1 0 1 0 5v51c0 4 3 6 6 4l42-27s2-1 2-3l-2-2"
            ]
            []
        ]


pause w h =
    svg
        [ width w
        , height h
        , viewBox "0 0 54 71"
        , class "db"
        ]
        [ Svg.Styled.path
            [ fill "#000"
            , fillOpacity "0.6"
            , fillRule "evenodd"
            , d "M45 0c-5 0-9 2-9 7v57c0 5 4 6 9 6 4 0 9-1 9-6V7c0-5-5-7-9-7M10 0C5 0 1 2 1 7v57c0 5 4 6 9 6 4 0 9-1 9-6V7c0-5-5-7-9-7"
            ]
            []
        ]


reset w h =
    svg
        [ width w
        , height h
        , viewBox "0 0 94 83"
        , class "db"
        ]
        [ Svg.Styled.path
            [ fill "#000"
            , fillOpacity "0.6"
            , fillRule "evenodd"
            , d "M53 1C31 1 13 19 12 41H0l18 20 19-20H23a31 31 0 1 1 12 26l-7 7c7 6 16 9 25 9a41 41 0 0 0 0-82"
            ]
            []
        ]


tomato w h =
    svg
        [ width w
        , height h
        , viewBox "0 0 232 232"
        , class "db"
        ]
        [ Svg.Styled.g
            [ fill "none"
            , fillRule "evenodd"
            , transform "rotate(20 113 118)"
            ]
            [ Svg.Styled.circle [ cx "115", cy "115", r "115", fill "#FF4700" ] []
            , Svg.Styled.circle [ cx "115", cy "115", r "95", fill "#FF7942" ] []
            , Svg.Styled.circle [ cx "115", cy "115", r "75", fill "#A20000" ] []
            , Svg.Styled.circle [ cx "115", cy "115", r "35", fill "#FF7942" ] []
            , Svg.Styled.path [ fill "#FF7942", d "M100 40h30v150h-30z" ] []
            , Svg.Styled.path [ fill "#F4B095", d "M85 67c2 2 4 5 4 10-4 0-8-1-10-3-4-3-5-7-4-9 2-2 6-1 10 2zM65 94c3 1 5 3 8 7-5 2-8 2-11 1-5-1-8-4-7-7 1-2 5-3 10-1zM62 132c3-1 6 0 11 1-2 5-5 7-8 8-4 2-9 1-10-1-1-3 2-6 7-8zM80 159c3-2 6-3 11-3-1 4-2 8-5 10-3 3-8 4-9 2-2-2 0-6 3-9z" ] []
            , Svg.Styled.path [ fill "#F4B095", d "M144 166c-2-2-4-5-4-10 4 0 8 1 10 3 4 3 5 7 4 9-2 2-6 1-10-2zM164 139c-3-1-5-3-8-7 5-2 8-2 11-1 5 1 8 4 7 7-1 2-5 3-10 1zM167 101c-3 1-6 0-11-1 2-5 5-7 8-8 4-2 9-1 10 1 1 3-2 6-7 8zM149 74c-3 2-6 3-11 3 1-4 2-8 5-10 3-3 8-4 9-2 2 2 0 6-3 9z" ] []
            ]
        ]
