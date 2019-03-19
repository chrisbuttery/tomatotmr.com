module StyledComponents exposing (blockButton, container, displayTime, drawer, drawerHeader, fakeRadialGradient, heading1, heading1Anchor, heading2, iconButton, lrgRoundButton, orange, range, rangeValue, rotate360, sharedRoundButtonStyle, smlRoundButton, styledLabel, switch, wrapper, yellow)

import Css exposing (..)
import Css.Animations as Anim exposing (Keyframes, keyframes)
import Css.Global exposing (children, descendants, selector, typeSelector, withClass)
import Css.Media exposing (withMediaQuery)
import Css.Transitions exposing (easeInOut, transition)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)


yellow =
    hex "fad8a4"


yellowLight =
    hex "fcebce"


yellowLightest =
    hex "fcebce"


orange =
    hex "ff6d2d"


blue =
    hex "ADE4EC"


blueDark =
    hex "537175"


white =
    hex "fff"


grey =
    hex "ccc"


greyLight =
    hex "ddd"


teko =
    [ "Teko", "sans-serif" ]


oswald =
    [ "Oswald", "sans-serif" ]


rotate360Frames : Keyframes {}
rotate360Frames =
    keyframes
        [ ( 0, [ Anim.transform [ rotate (deg 0) ] ] )
        , ( 100, [ Anim.transform [ rotate (deg 360) ] ] )
        ]


rotate360 : List (Attribute msg) -> List (Html msg) -> Html msg
rotate360 =
    styled
        span
        [ animationName rotate360Frames
        , property "animation-duration" "15s"
        , property "animation-iteration-count" "infinite"
        , property "animation-timing-function" "linear"
        ]


wrapper : List (Attribute msg) -> List (Html msg) -> Html msg
wrapper =
    styled
        div
        [ backgroundColor orange
        , textAlign center
        , transition
            [ Css.Transitions.backgroundColor 250 ]
        , withClass
            "break"
            [ backgroundColor blue ]
        ]



-- elm-css doesnt not produce a radialGradient, so lets fake it


fakeRadialGradient : List (Attribute msg) -> List (Html msg) -> Html msg
fakeRadialGradient =
    styled
        span
        [ backgroundColor (rgba 231 255 159 0.5)
        , borderRadius (pct 50)
        , boxShadow6 inset zero zero (px 200) (px 150) orange
        , height (px 700)
        , left (pct 50)
        , transform (translateX (pct -50))
        , width (px 700)
        , withClass
            "break"
            [ boxShadow6 inset zero zero (px 200) (px 150) blue ]
        , transition
            [ Css.Transitions.boxShadow 250 ]
        ]


container : List (Attribute msg) -> List (Html msg) -> Html msg
container =
    styled
        div
        [ maxWidth (px 500) ]


sharedRoundButtonStyle : Style
sharedRoundButtonStyle =
    batch
        [ backgroundColor yellowLightest
        , borderRadius (pct 50)
        , boxShadow5 (px 0) (px 2) (px 0) (px 1) (rgba 0 0 0 0.2)
        , color (rgba 0 0 0 0.5)
        , hover
            [ backgroundColor yellowLight ]
        , active
            [ boxShadow5 (px 0) (px 1) (px 0) (px 0) (rgba 0 0 0 0.2)
            , transform (translateY (px 3))
            ]
        , transition
            [ Css.Transitions.backgroundColor 250
            , Css.Transitions.boxShadow 250
            , Css.Transitions.color 250
            , Css.Transitions.transform 250
            ]
        ]


smlRoundButton : List (Attribute msg) -> List (Html msg) -> Html msg
smlRoundButton =
    styled
        button
        [ sharedRoundButtonStyle
        , backgroundColor (rgba 255 255 255 0.8)
        , height (px 70)
        , top (pct 50)
        , transform (translateY (pct -50))
        , width (px 70)
        , active
            [ transform (translateY (pct -47)) ]
        ]


lrgRoundButton : List (Attribute msg) -> List (Html msg) -> Html msg
lrgRoundButton =
    styled
        button
        [ sharedRoundButtonStyle
        , height (px 100)
        , width (px 100)
        ]


sharedWell : Style
sharedWell =
    batch
        [ backgroundColor (rgba 255 255 255 0.1)
        , hover
            [ backgroundColor (rgba 255 255 255 0.3) ]
        , transition
            [ Css.Transitions.backgroundColor 250 ]
        ]


iconButton : List (Attribute msg) -> List (Html msg) -> Html msg
iconButton =
    styled
        span
        [ sharedWell ]


blockButton : List (Attribute msg) -> List (Html msg) -> Html msg
blockButton =
    styled
        button
        [ backgroundColor (rgba 255 255 255 0.6)
        , boxShadow5 (px 0) (px 2) (px 0) (px 1) (rgba 0 0 0 0.2)
        , color (rgba 0 0 0 0.4)
        , fontFamilies teko
        , fontSize (px 30)
        , lineHeight (px 36)
        , withClass
            "active"
            [ backgroundColor yellowLightest
            , boxShadow5 (px 0) (px 1) (px 0) (px 0) (rgba 0 0 0 0.2)
            , color (rgba 0 0 0 0.6)
            , top (px 1)
            ]
        , hover
            [ backgroundColor yellowLight
            , color (rgba 0 0 0 0.6)
            ]
        , transition
            [ Css.Transitions.backgroundColor 250
            , Css.Transitions.boxShadow 250
            , Css.Transitions.color 250
            , Css.Transitions.top 250
            ]
        ]


heading1 : List (Attribute msg) -> List (Html msg) -> Html msg
heading1 =
    styled
        h1
        [ fontFamilies oswald
        , fontSize (px 12)
        ]


heading1Anchor : List (Attribute msg) -> List (Html msg) -> Html msg
heading1Anchor =
    styled
        a
        [ sharedWell
        , color (rgba 0 0 0 0.5)
        , hover
            [ color (rgba 0 0 0 0.7)
            ]
        , transition
            [ Css.Transitions.color 250 ]
        ]


heading2 : List (Attribute msg) -> List (Html msg) -> Html msg
heading2 =
    styled
        h2
        [ fontFamilies oswald
        , fontSize (px 60)
        , transform (rotate (deg -6))
        , withClass
            "break"
            [ color blueDark ]
        , withMediaQuery
            [ "screen and (min-width: 40em)" ]
            [ fontSize (px 80)
            , lineHeight (px 80)
            ]
        , transition
            [ Css.Transitions.boxShadow 250 ]
        ]


styledLabel : List (Attribute msg) -> List (Html msg) -> Html msg
styledLabel =
    styled
        p
        [ fontFamilies teko
        , fontSize (px 30)
        ]


displayTime : List (Attribute msg) -> List (Html msg) -> Html msg
displayTime =
    styled
        p
        [ color (rgb 0 0 0)
        , fontSize (px 120)
        , fontFamilies oswald
        , textShadow4 (px 0) (px 3) (px 3) (rgba 0 0 0 0.2)
        , withMediaQuery
            [ "screen and (min-width: 40em)" ]
            [ fontSize (px 200) ]
        ]


drawer : List (Attribute msg) -> List (Html msg) -> Html msg
drawer =
    styled
        div
        [ backgroundColor (rgba 0 0 0 0.8)
        , minWidth (px 300)
        , transition
            [ Css.Transitions.right3 250 0 easeInOut ]
        , withClass
            "hidden"
            [ right (pct -100) ]
        ]


drawerHeader : List (Attribute msg) -> List (Html msg) -> Html msg
drawerHeader =
    styled
        h3
        [ fontFamilies teko
        , fontSize (px 36)
        ]


rangeValue : List (Attribute msg) -> List (Html msg) -> Html msg
rangeValue =
    styled
        span
        [ color yellow ]


switch : List (Attribute msg) -> List (Html msg) -> Html msg
switch =
    styled
        span
        [ backgroundColor grey
        , borderRadius (px 20)
        , height (px 20)
        , width (px 40)
        , after
            [ backgroundColor greyLight
            , borderRadius (pct 50)
            , display block
            , height (px 16)
            , left (px 2)
            , position absolute
            , property "content" "''"
            , top (pct 50)
            , transform (translateY (pct -50))
            , width (px 16)
            ]
        , withClass
            "active"
            [ backgroundColor white
            , transform (rotate (deg 180))
            , after
                [ backgroundColor yellow ]
            ]
        ]


foo =
  styled
    div [
      property "box-shadow" "inset 0 2px 0px #666, 0 2px 5px #000"
    ]

range : List (Attribute msg) -> List (Html msg) -> Html msg
range =
    styled
        input
        [ backgroundColor transparent
        , height (px 36)
        , property "-webkit-appearance" "none"
        , pseudoElement "-webkit-slider-runnable-track"
            [ backgroundColor greyLight
            , border (px 0)
            , borderRadius (px 3)
            , height (px 5)
            , width (px 300)
            ]
        , pseudoElement "-webkit-slider-thumb"
            [ border (px 0)
            , borderRadius (pct 50)
            , backgroundColor yellow
            , height (px 16)
            , marginTop (px -5)
            , property "-webkit-appearance" "none"
            , width (px 16)
            ]
        , pseudoElement "focus"
            [ outline none
            , pseudoElement "-webkit-slider-runnable-track"
                [ backgroundColor white
                ]
            ]
        ]
