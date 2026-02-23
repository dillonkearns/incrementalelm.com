module View.DripSignupForm exposing (viewNew, viewNew2)

import Html exposing (..)
import Html.Attributes exposing (..)
import Tailwind as Tw exposing (classes)
import Tailwind.Theme exposing (accent1, s1, s2, s4)


dripAttribute : String -> Attribute msg
dripAttribute =
    attribute "data-drip-attribute"


emailInput : Html msg
emailInput =
    dripInput
        { inputId = "drip-email"
        , type_ = "email"
        , labelText = "Email"
        , name = "fields[email]"
        , display = Show
        , value = Nothing
        }


firstNameInput : Html msg
firstNameInput =
    dripInput
        { inputId = "drip-first-name"
        , type_ = "text"
        , labelText = "Your first name"
        , name = "fields[first_name]"
        , display = Show
        , value = Nothing
        }


dripInput : { a | display : Display, inputId : String, labelText : String, type_ : String, name : String, value : Maybe String } -> Html msg
dripInput details =
    div
        (case details.display of
            Show ->
                [ style "margin-bottom" "20px"
                , style "font-weight" "bold"
                , classes
                    [ Tw.grow
                    ]
                ]

            Hide ->
                [ style "display" "none", attribute "aria-hidden" "true" ]
        )
        [ label [ for details.inputId ] [ text details.labelText ]
        , br [] []
        , input
            ([ type_ details.type_
             , id details.inputId
             , name details.name
             , classes
                [ Tw.w_full
                , Tw.raw "border-foreground-light"
                , Tw.border_2
                , Tw.raw "border-solid"
                , Tw.raw "rounded-md"
                , Tw.pt s1
                , Tw.mt s1
                ]
             ]
                |> includeValueIfPresent details.value
            )
            []
        ]


includeValueIfPresent : Maybe String -> List (Attribute msg) -> List (Attribute msg)
includeValueIfPresent maybeValue list =
    case maybeValue of
        Just actualValue ->
            value actualValue :: list

        Nothing ->
            list


websiteField : Html msg
websiteField =
    dripInput
        { inputId = "website"
        , type_ = "text"
        , labelText = "Website"
        , name = "website"
        , display = Hide
        , value = Just ""
        }


type Display
    = Hide
    | Show


referenceIdInput : Maybe String -> Html msg
referenceIdInput maybeReferenceId =
    div [ style "display" "none", attribute "aria-hidden" "true" ]
        [ label [ for "drip-reference-id" ] [ text "Reference ID" ]
        , br [] []
        , input
            [ type_ "text"
            , id "drip-reference-id"
            , name "fields[reference_id]"
            , maybeReferenceId |> Maybe.withDefault "" |> value
            ]
            []
        ]


viewNew : String -> String -> { details | maybeReferenceId : Maybe String } -> Html msg
viewNew buttonText formId signupDetails =
    Html.form
        [ action <| "https://www.getdrip.com/forms/" ++ formId ++ "/submissions"
        , method "post"
        , attribute "data-drip-embedded-form" formId
        , style "font-family" "'Open Sans'"
        , classes [ Tw.p s4 ]
        ]
        [ h2 [ dripAttribute "headline", style "display" "none" ] [ text "Incremental Elm" ]
        , div [ dripAttribute "description" ] []
        , emailInput
        , firstNameInput
        , referenceIdInput signupDetails.maybeReferenceId
        , websiteField
        , div
            []
            [ input
                [ class "button"
                , dripAttribute "sign-up-button"
                , name "subscribe"
                , type_ "submit"
                , value buttonText
                , style "width" "100%"
                , classes
                    [ Tw.bg_simple accent1
                    , Tw.cursor_pointer
                    , Tw.p s2
                    , Tw.raw "text-white"
                    , Tw.raw "hover:bg-accent2"
                    ]
                ]
                []
            ]
        ]


viewNew2 : String -> String -> { details | maybeReferenceId : Maybe String } -> Html msg
viewNew2 buttonText formId signupDetails =
    Html.form
        [ action <| "https://www.getdrip.com/forms/" ++ formId ++ "/submissions"
        , method "post"
        , attribute "data-drip-embedded-form" formId
        , style "font-family" "'Open Sans'"
        , classes [ Tw.p s4 ]
        ]
        [ h2 [ dripAttribute "headline", style "display" "none" ] [ text "Incremental Elm" ]
        , div [ dripAttribute "description" ] []
        , referenceIdInput signupDetails.maybeReferenceId
        , div
            [ classes
                [ Tw.flex
                , Tw.w_full
                , Tw.raw "gap-4"
                ]
            ]
            [ emailInput
            , firstNameInput
            ]
        , websiteField
        , div []
            [ input
                [ class "button"
                , dripAttribute "sign-up-button"
                , name "subscribe"
                , type_ "submit"
                , value buttonText
                , style "width" "100%"
                , classes
                    [ Tw.cursor_pointer
                    , Tw.p s2
                    , Tw.raw "rounded-lg"
                    , Tw.raw "bg-gradient-to-b"
                    , Tw.raw "from-accent1"
                    , Tw.raw "font-bold"
                    , Tw.raw "text-lg"
                    , Tw.raw "to-highlight"
                    , Tw.raw "text-white"
                    , Tw.raw "hover:bg-gradient-to-b"
                    , Tw.raw "hover:from-accent1"
                    , Tw.raw "hover:to-accent2"
                    ]
                ]
                []
            ]
        ]
