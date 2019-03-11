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
                []

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

        -- <div>
        --   <input type="submit" value="Sign Up" data-drip-attribute="sign-up-button" />
        -- </div>
        -- , div [ id "mc_embed_signup_scroll" ]
        --     [ fieldGroup { name = "EMAIL", display = "Email Address" }
        --     , fieldGroup { name = "FNAME", display = "First Name" }
        --     , fieldGroup { name = "LNAME", display = "Last Name" }
        --     , fieldGroup_ { hidden = True, defaultValue = maybeReferenceId, display = "Reference ID", name = "REFERENCE" }
        --     ]
        -- , mailchimpGroups
        -- , closingContents
        -- , div [ attribute "aria-hidden" "true", attribute "style" "position: absolute; left: -5000px;" ]
        --     [ input [ name "b_8252abc4ac213a3cdf1832799_c68ad2ba25", attribute "tabindex" "-1", type_ "text", value "" ]
        --         []
        --     ]
        -- , div [ class "clear" ]
        --     [ submitButton
        --     ]
        ]


fieldGroup : { display : String, name : String } -> Html msg
fieldGroup values =
    fieldGroup_
        { hidden = False
        , defaultValue = Nothing
        , display = values.display
        , name = values.name
        }


fieldGroup_ : { hidden : Bool, defaultValue : Maybe String, display : String, name : String } -> Html msg
fieldGroup_ options =
    div
        [ class "mc-field-group"
        , if options.hidden then
            style "display" "none"

          else
            style "margin-top" "10px"
        ]
        [ label [ for <| "mce-" ++ options.name ] [ text options.display ]
        , div [] []
        , input
            [ type_ "email"
            , options.defaultValue |> Maybe.withDefault "" |> value
            , name options.name
            , id <| "mce-" ++ options.name
            , style "appearance" "none"
            , style "-webkit-appearance" "none"
            , style "-moz-appearance" "none"
            , style "border-radius" "4px"
            , style "border" "2px solid #d0d0d0"
            , style "padding-top" "10px"
            , style "padding-left" "10px"
            , style "padding-right" "10px"
            , style "font-family" "Raleway"
            , style "font-size" "20px"
            , style "margin-top" "10px"
            ]
            []
        ]


mailchimpGroups =
    div
        [ class "mc-field-group input-group"
        , style "display" "none"
        ]
        [ strong []
            [ text "Interests " ]
        , ul []
            [ li []
                [ input [ id "mce-group[76553]-76553-0", name "group[76553][1]", type_ "checkbox", value "1" ]
                    []
                , label [ for "mce-group[76553]-76553-0" ]
                    [ text "Elm Training" ]
                ]
            , li []
                [ input [ id "mce-group[76553]-76553-1", name "group[76553][2]", type_ "checkbox", value "2" ]
                    []
                , label [ for "mce-group[76553]-76553-1" ]
                    [ text "Redux => Elm" ]
                ]
            , li []
                [ input
                    [ id "mce-group[76553]-76553-2"
                    , name "group[76553][4]"
                    , type_ "checkbox"
                    , value "4"
                    , checked True
                    ]
                    []
                , label [ for "mce-group[76553]-76553-2" ]
                    [ text "GraphQL and Elm" ]
                ]
            ]
        ]


closingContents =
    div [ class "clear", id "mce-responses" ]
        [ div [ class "response", id "mce-error-response", attribute "style" "display:none" ]
            []
        , div [ class "response", id "mce-success-response", attribute "style" "display:none" ]
            []
        ]


submitButton : Html msg
submitButton =
    input
        [ class "button"
        , id "mc-embedded-subscribe"
        , name "subscribe"
        , type_ "submit"
        , value "Subscribe"
        , style "font-size" "18px"
        , style "font-family" "Open Sans"
        , style "margin-top" "10px"
        ]
        []
