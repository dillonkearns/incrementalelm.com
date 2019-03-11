module View.DripSignupForm exposing (view)

import Element exposing (Element)
import Element.Region
import Html exposing (..)
import Html.Attributes exposing (..)



{-
   <form action="https://www.getdrip.com/forms/375406512/submissions" method="post" data-drip-embedded-form="375406512">
     <h3 data-drip-attribute="headline">Incremental Elm</h3>
     <div data-drip-attribute="description"></div>
       <div>
           <label for="drip-email">Email Address</label><br />
           <input type="email" id="drip-email" name="fields[email]" value="" />
       </div>
       <div>
           <label for="drip-first-name">First</label><br />
           <input type="text" id="drip-first-name" name="fields[first_name]" value="" />
       </div>
       <div>
           <label for="drip-last-name">Last</label><br />
           <input type="text" id="drip-last-name" name="fields[last_name]" value="" />
       </div>




     <div style="display: none;" aria-hidden="true">
       <label for="website">Website</label><br />
       <input type="text" id="website" name="website" tabindex="-1" autocomplete="false" value="" />
     </div>
     <div>
       <input type="submit" value="Sign Up" data-drip-attribute="sign-up-button" />
     </div>




   </form>

-}


dripAttribute =
    Html.Attributes.attribute "data-drip-attribute"


emailInput =
    div []
        [ label [ for "drip-email" ] [ text "Email Address" ]
        , br [] []
        , input [ type_ "email", id "drip-email", name "fields[email]" ] []
        ]


firstNameInput =
    div []
        [ label [ for "drip-first-name" ] [ text "First" ]
        , br [] []
        , input [ type_ "text", id "drip-first-name", name "fields[first_name]" ] []
        ]


lastNameInput =
    div []
        [ label [ for "drip-last-name" ] [ text "Last" ]
        , br [] []
        , input [ type_ "text", id "drip-last-name", name "fields[last_name]" ] []
        ]


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


websiteField =
    div [ style "display" "none", attribute "aria-hidden" "true" ]
        [ label [ for "website" ] [ text "Website" ]
        , br [] []
        , input [ type_ "text", id "website", name "website", tabindex -1, autocomplete False, value "" ] []
        ]
