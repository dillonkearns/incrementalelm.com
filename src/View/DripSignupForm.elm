module View.DripSignupForm exposing (viewNew, viewNew2)

import Css
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw


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
                , css
                    [ Tw.flex_grow
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
             , css
                [ Tw.w_full
                , Tw.border_foregroundLight
                , Tw.border_2
                , Tw.border_solid
                , Tw.rounded_md
                , Tw.pt_1
                , Tw.mt_1
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
    Html.Styled.form
        [ action <| "https://www.getdrip.com/forms/" ++ formId ++ "/submissions"
        , method "post"
        , attribute "data-drip-embedded-form" formId
        , style "font-family" "'Open Sans'"
        , css [ Tw.p_4 ]
        ]
        [ h2 [ dripAttribute "headline", style "display" "none" ] [ text "Incremental Elm" ]
        , div [ dripAttribute "description" ] []
        , emailInput
        , firstNameInput
        , referenceIdInput signupDetails.maybeReferenceId
        , websiteField
        , div
            [ css
                []
            ]
            [ input
                [ class "button"
                , dripAttribute "sign-up-button"
                , name "subscribe"
                , type_ "submit"
                , value buttonText
                , style "width" "100%"
                , css
                    [ Tw.bg_accent1
                    , Tw.cursor_pointer
                    , Tw.p_2
                    , Tw.text_white
                    , Css.hover
                        [ Tw.bg_accent2
                        ]
                    ]
                ]
                []
            ]
        ]


viewNew2 : String -> String -> { details | maybeReferenceId : Maybe String } -> Html msg
viewNew2 buttonText formId signupDetails =
    Html.Styled.form
        [ action <| "https://www.getdrip.com/forms/" ++ formId ++ "/submissions"
        , method "post"
        , attribute "data-drip-embedded-form" formId
        , style "font-family" "'Open Sans'"
        , css [ Tw.p_4 ]
        ]
        [ h2 [ dripAttribute "headline", style "display" "none" ] [ text "Incremental Elm" ]
        , div [ dripAttribute "description" ] []
        , referenceIdInput signupDetails.maybeReferenceId
        , div
            [ css
                [ Tw.flex
                , Tw.w_full
                , Tw.gap_4
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
                , css
                    [ Tw.cursor_pointer
                    , Tw.p_2
                    , Tw.rounded_lg
                    , Tw.bg_gradient_to_b
                    , Tw.from_accent1
                    , Tw.font_bold
                    , Tw.text_lg

                    --, Tw.to_accent2
                    , Tw.to_highlight
                    , Tw.text_white
                    , Css.hover
                        [ Tw.bg_gradient_to_b
                        , Tw.from_accent1
                        , Tw.to_accent2
                        ]
                    ]
                ]
                []
            ]
        ]
