module View.DripSignupForm exposing (viewNew)

import Html exposing (..)
import Html.Attributes exposing (..)


dripAttribute : String -> Attribute msg
dripAttribute =
    attribute "data-drip-attribute"


emailInput : Html msg
emailInput =
    dripInput
        { inputId = "drip-email"
        , type_ = "email"
        , labelText = "Email Address"
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
                [ style "margin-bottom" "20px", style "font-weight" "bold" ]

            Hide ->
                [ style "display" "none", attribute "aria-hidden" "true" ]
        )
        [ label [ for details.inputId ] [ text details.labelText ]
        , br [] []
        , input
            ([ type_ details.type_
             , id details.inputId
             , name details.name
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
        ]
        [ h2 [ dripAttribute "headline", style "display" "none" ] [ text "Incremental Elm" ]
        , div [ dripAttribute "description" ] []
        , emailInput
        , firstNameInput
        , referenceIdInput signupDetails.maybeReferenceId
        , websiteField
        , div []
            [ input
                [ class "button"
                , dripAttribute "sign-up-button"
                , name "subscribe"
                , type_ "submit"
                , value buttonText
                , style "width" "100%"
                ]
                []
            ]
        ]
