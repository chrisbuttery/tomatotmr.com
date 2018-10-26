port module Main exposing (main)

import Browser
import Css exposing (..)
import Debug
import Html
import Html.Attributes exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, classList, css, href, max, min, name, src, title, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Process
import StyledComponents exposing (..)
import Tachyons exposing (tachyonsStylesheet)
import Tachyons.Classes as T
import Task exposing (..)
import Time exposing (..)
import Vectors as Vector


port emitComplete : () -> Cmd msg


port emitPageTitle : String -> Cmd msg


type alias Model =
    { seconds : Int
    , minutes : Int
    , time : Maybe Posix
    , state : TimerState
    , mode : TimerMode
    , break : Int
    , work : Int
    , autoPlay : Bool
    , showSettings : Bool
    }


type alias Flags =
    {}


type TimerState
    = Paused
    | Started
    | Resetting
    | PreStart


type TimerMode
    = Pomodoro
    | Break


pomodoro =
    25


break =
    5


defaultRange =
    10


minRange =
    1


maxWorkRange =
    60


maxBreakRange =
    30


defaultMinutes =
    pomodoro


defaultSeconds =
    0


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view >> toUnstyled
        , subscriptions = subscriptions
        }


run : msg -> Cmd msg
run m =
    Task.perform (always m) (Task.succeed ())


formatPageTitle : Model -> String
formatPageTitle model =
    let
        appName =
            "TomatoTmr"

        mins =
            if
                model.seconds
                    == 0
                    && model.mode
                    == Pomodoro
                    && model.minutes
                    == model.work
                    || model.mode
                    == Break
                    && model.minutes
                    == model.break
            then
                model.minutes - 1

            else
                model.minutes

        secs =
            if model.minutes /= 0 && model.seconds == 0 then
                59

            else if model.minutes == 0 && model.seconds == 0 then
                model.seconds

            else
                model.seconds - 1
    in
    if model.state == Started || model.state == PreStart then
        formatTime mins ++ ":" ++ formatTime secs ++ " | " ++ appName

    else
        appName


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.state of
        Started ->
            Time.every 1000 Tick

        PreStart ->
            Sub.none

        Resetting ->
            Sub.none

        Paused ->
            Sub.none


initialModel : Model
initialModel =
    { minutes = defaultMinutes
    , seconds = defaultSeconds
    , state = Paused
    , mode = Pomodoro
    , time = Nothing
    , break = break
    , work = pomodoro
    , autoPlay = False
    , showSettings = False
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initialModel, Cmd.none )


type Msg
    = Start
    | Pause
    | Reset
    | Tick Posix
    | DelayStart
    | SwitchMode TimerMode
    | WorkRange String
    | BreakRange String
    | ToggleAutoPlay
    | ToggleSettings
    | BeforeStart


getRangeValueFromString : String -> Int
getRangeValueFromString str =
    case String.toInt str of
        Nothing ->
            0

        Just num ->
            num


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Pause ->
            ( { model | state = Paused }, Cmd.none )

        Reset ->
            let
                minutes =
                    case model.mode of
                        Pomodoro ->
                            model.work

                        Break ->
                            model.break

                newModel =
                    { model
                        | state = Resetting
                        , minutes = minutes
                        , seconds = defaultSeconds
                    }
            in
            ( newModel
            , emitPageTitle <| formatPageTitle newModel
            )

        Start ->
            let
                minutes =
                    if model.minutes > 0 && model.seconds > 0 then
                        model.minutes

                    else if model.minutes > 0 && model.seconds == 0 then
                        model.minutes - 1

                    else
                        0

                seconds =
                    if model.seconds > 0 then
                        model.seconds - 1

                    else if model.minutes > 0 && model.seconds == 0 then
                        59

                    else
                        0

                mode =
                    if model.mode == Pomodoro then
                        Break

                    else
                        Pomodoro

                commands =
                    if minutes == 0 && seconds == 0 then
                        if model.autoPlay == True then
                            Cmd.batch
                                [ emitPageTitle <| formatPageTitle model
                                , emitComplete ()
                                , run (SwitchMode mode)
                                , Process.sleep 1000 |> Task.perform (always Start)
                                ]

                        else
                            Cmd.batch
                                [ emitPageTitle <| formatPageTitle model
                                , emitComplete ()
                                , run Pause
                                ]

                    else
                        emitPageTitle <| formatPageTitle model
            in
            ( { model
                | state = Started
                , seconds = seconds
                , minutes = minutes
              }
            , commands
            )

        Tick time ->
            ( { model | time = Just time }, run Start )

        DelayStart ->
            ( model, Process.sleep 1000 |> Task.perform (always Start) )

        SwitchMode m ->
            let
                commands =
                    if model.autoPlay == True then
                        Cmd.batch [ run DelayStart, run Reset ]

                    else
                        run Reset
            in
            ( { model | mode = m }, commands )

        WorkRange str ->
            let
                range =
                    getRangeValueFromString str
            in
            ( { model | work = range, minutes = range, seconds = 0, mode = Pomodoro }, Cmd.none )

        BreakRange str ->
            let
                range =
                    getRangeValueFromString str
            in
            ( { model | break = range, minutes = range, seconds = 0, mode = Break }, Cmd.none )

        ToggleAutoPlay ->
            ( { model | autoPlay = not model.autoPlay }, Cmd.none )

        ToggleSettings ->
            ( { model | showSettings = not model.showSettings }, Cmd.none )

        BeforeStart ->
            ( { model | state = PreStart }, Cmd.batch [ emitPageTitle <| formatPageTitle model, run DelayStart ] )


zeroPadNumber : Int -> String
zeroPadNumber n =
    String.fromInt n |> String.padLeft 2 '0'


formatTime : Int -> String
formatTime n =
    if n < 10 then
        zeroPadNumber n

    else
        String.fromInt n



-- Use elm-css class 'Attribute' Type to join strings


classes : List String -> Attribute msg
classes stringList =
    class (String.join " " stringList)


rangeInput : (String -> Msg) -> String -> Int -> String -> Int -> Html Msg
rangeInput msg lbl val nme maxRange =
    div []
        [ styledLabel
            [ class T.white ]
            [ text (lbl ++ " : ")
            , rangeValue [] [ text (String.fromInt val ++ "min") ]
            ]
        , range
            [ type_ "range"
            , class T.w_100
            , name nme
            , min <| String.fromInt minRange
            , max <| String.fromInt maxRange
            , value <| String.fromInt val
            , onInput msg
            ]
            []
        ]


isBreakMode : TimerMode -> Attribute msg
isBreakMode mode =
    classList [ ( "break", mode == Break ) ]


drawerView : Model -> Html Msg
drawerView model =
    drawer
        [ classes [ T.absolute, T.top_0, T.bottom_0, T.right_0, T.z_1 ]
        , classList [ ( "hidden", model.showSettings == False ) ]
        ]
        [ drawerHeader
            [ classes [ T.relative, T.flex, T.items_center, T.ma0, T.pa4, T.fw3 ], isBreakMode model.mode ]
            [ iconButton
                [ classes [ T.absolute, T.top_1, T.pa2, T.right_1, T.top_2_ns, T.right_2_ns, T.pointer ]
                , onClick ToggleSettings
                ]
                [ Vector.close "16" "16" ]
            , text "Settings"
            ]
        , div [ classes [ T.pa4, T.tl ] ]
            [ rangeInput WorkRange "Pomodoro" model.work "workRange" maxWorkRange
            , rangeInput BreakRange "Break" model.break "breakRange" maxBreakRange
            , div
                [ class T.white ]
                [ styledLabel [] [ text "Autoplay" ]
                , switch
                    [ classList [ ( "active", model.autoPlay == True ) ]
                    , onClick ToggleAutoPlay
                    ]
                    [ text "" ]
                ]
            ]
        ]



-- stateButton : Msg -> String -> Html Msg


actionsView : TimerState -> Html Msg
actionsView state =
    let
        mainButton =
            if state == PreStart || state == Started then
                lrgRoundButton
                    [ classes [ T.center, T.flex, T.items_center, T.justify_center ]
                    , onClick Pause
                    ]
                    [ Vector.pause "30" "30" ]

            else
                lrgRoundButton
                    [ classes [ T.center, T.flex, T.items_center, T.justify_center ]
                    , onClick BeforeStart
                    ]
                    [ Vector.start "30" "30" ]
    in
    div [ classes [ T.relative, T.center, T.w_60_ns ] ]
        [ mainButton
        , smlRoundButton
            [ classes [ T.absolute, T.right_1, T.right_0_ns, T.flex, T.items_center, T.justify_center ], onClick Reset ]
            [ Vector.reset "30" "30"
            ]
        ]


modeButtonsView : TimerMode -> Html Msg
modeButtonsView mode =
    div [ classes [ T.w_100, T.mt4, T.mt5_ns ] ]
        [ blockButton
            [ classes [ T.w_40, T.w_30_ns, T.tc, T.ph0, T.pt2, T.fw3, T.relative, T.z_1, T.mr2 ]
            , classList [ ( "active", mode == Pomodoro ) ]
            , onClick (SwitchMode Pomodoro)
            ]
            [ text "Pomodoro" ]
        , blockButton
            [ classes [ T.w_40, T.w_30_ns, T.tc, T.ph0, T.pt2, T.fw3, T.relative, T.z_1, T.ml2 ]
            , classList [ ( "active", mode /= Pomodoro ) ]
            , onClick (SwitchMode Break)
            ]
            [ text "Break" ]
        ]


titleView : TimerMode -> TimerState -> Html Msg
titleView mode state =
    let
        wrapper =
            if state == PreStart || state == Started then
                rotate360

            else
                span
    in
    heading2
        [ classes [ T.ma0, T.fw1, T.z_1, T.lh_solid, T.flex, T.items_center, T.justify_center, T.white ]
        , isBreakMode mode
        ]
        [ wrapper [] [ Vector.tomato "110" "110" ]
        , span [ class T.ml2 ] [ text "Tmr" ]
        ]


timeView : Int -> Int -> Html Msg
timeView minutes seconds =
    displayTime [ classes [ T.white, T.ma0, T.mv4, T.mb5_ns, T.fw3, T.tc, T.lh_solid, T.flex, T.items_center, T.justify_center ] ]
        [ span [ classes [ T.w_40, T.tr ] ] [ text (formatTime minutes) ]
        , span [ class T.w_10 ] [ text ":" ]
        , span [ classes [ T.w_40, T.tl ] ] [ text (formatTime seconds) ]
        ]


settingsView : Bool -> Html Msg
settingsView showSettings =
    iconButton
        [ classes [ T.pa2, T.absolute, T.top_1, T.right_1, T.top_2_ns, T.right_2_ns, T.z_5, T.pointer ]
        , classList [ ( T.dn, showSettings == True ) ]
        , onClick ToggleSettings
        ]
        [ Vector.settings "16" "16" ]


view : Model -> Html Msg
view model =
    let
        desc =
            "A Pomodoro Tomato Timer crafted with elm-lang, elm-css and tachyons-elm by Chris Buttery"
    in
    wrapper
        [ classes [ T.overflow_hidden, T.relative, T.h_100, T.ph3, T.ph0_ns ]
        , isBreakMode model.mode
        ]
        [ container
            [ classes [ T.h_100, T.center, T.relative, T.pt4, T.pt5_ns, T.pb6_ns, T.z_1 ] ]
            [ node "style" [] [ text tachyonsStylesheet ]
            , heading1 [ classes [ T.absolute, T.bottom_0, T.ma0, T.fw1, T.lh_title ] ]
                [ heading1Anchor
                    [ classes [ T.pa2, T.db, T.link, T.underline_hover ]
                    , href "http://www.chrisbuttery.com"
                    , title desc
                    ]
                    [ text desc ]
                ]
            , titleView model.mode model.state
            , modeButtonsView model.mode
            , timeView model.minutes model.seconds
            , actionsView model.state
            ]
        , settingsView model.showSettings
        , drawerView model
        , fakeRadialGradient [ classes [ T.absolute, T.top_0, T.top_2_ns, T.z_0 ], isBreakMode model.mode ] []
        ]
