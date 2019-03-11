module View.DripSignupForm exposing (view)

import Element exposing (Element)
import Element.Region
import Html exposing (..)
import Html.Attributes exposing (..)


dripAttribute =
    Html.Attributes.attribute "data-drip-attribute"


emailInput =
    dripInput
        { inputId = "drip-email"
        , type_ = "email"
        , labelText = "Email Address"
        , name = "fields[email]"
        , display = Show
        , value = Nothing
        }


firstNameInput =
    dripInput
        { inputId = "drip-first-name"
        , type_ = "text"
        , labelText = "First"
        , name = "fields[first_name]"
        , display = Show
        , value = Nothing
        }


dripInput details =
    div
        (case details.display of
            Show ->
                [ style "margin-bottom" "20px" ]

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


includeValueIfPresent maybeValue list =
    case maybeValue of
        Just actualValue ->
            value actualValue :: list

        Nothing ->
            list


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


lastNameInput =
    dripInput
        { inputId = "drip-last-name"
        , type_ = "text"
        , labelText = "Last"
        , name = "fields[last_name]"
        , display = Show
        , value = Just ""
        }


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


view : Maybe String -> Html msg
view maybeReferenceId =
    Html.form
        [ action "https://www.getdrip.com/forms/375406512/submissions"
        , method "post"
        , Html.Attributes.attribute "data-drip-embedded-form" "375406512"
        , style "font-family" "'Open Sans'"
        ]
        [ h2 [ dripAttribute "headline", style "display" "none" ] [ text "Incremental Elm" ]
        , div [ dripAttribute "description" ] []
        , emailInput
        , firstNameInput
        , lastNameInput
        , referenceIdInput maybeReferenceId
        , websiteField
        , div []
            [ input
                [ class "button"
                , dripAttribute "sign-up-button"
                , name "subscribe"
                , type_ "submit"
                , value "Subscribe"
                ]
                []
            ]
        ]
