module View.SignupForm exposing (view)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)


view : Maybe String -> Html msg
view maybeReferenceId =
    div [ id "mc_embed_signup" ]
        [ Html.form
            [ action "https://incrementalelm.us7.list-manage.com/subscribe/post?u=8252abc4ac213a3cdf1832799&amp;id=c68ad2ba25"
            , method "post"
            , id "mc-embedded-subscribe-form"
            , name "mc-embedded-subscribe-form"
            , class "validate"
            , target "_blank"
            , novalidate True
            ]
            [ div [ id "mc_embed_signup_scroll" ]
                [ fieldGroup { name = "EMAIL", display = "Email Address" }
                , fieldGroup { name = "FNAME", display = "First Name" }
                , fieldGroup { name = "LNAME", display = "Last Name" }
                , fieldGroup_ { hidden = True, defaultValue = maybeReferenceId, display = "Reference ID", name = "REFERENCE" }
                ]
            , mailchimpGroups
            , closingContents
            , div [ attribute "aria-hidden" "true", attribute "style" "position: absolute; left: -5000px;" ]
                [ input [ name "b_8252abc4ac213a3cdf1832799_c68ad2ba25", attribute "tabindex" "-1", type_ "text", value "" ]
                    []
                ]
            , div [ class "clear" ]
                [ submitButton
                ]
            ]
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
