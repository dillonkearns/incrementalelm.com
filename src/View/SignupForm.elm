module View.SignupForm exposing (view)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)


view : Html msg
view =
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
                ]
            , mailchimpGroups
            , closingContents
            , div [ attribute "aria-hidden" "true", attribute "style" "position: absolute; left: -5000px;" ]
                [ input [ name "b_8252abc4ac213a3cdf1832799_c68ad2ba25", attribute "tabindex" "-1", type_ "text", value "" ]
                    []
                ]
            , div [ class "clear" ]
                [ input [ class "button", id "mc-embedded-subscribe", name "subscribe", type_ "submit", value "Subscribe" ]
                    []
                ]
            ]
        ]


fieldGroup : { display : String, name : String } -> Html msg
fieldGroup values =
    div [ class "mc-field-group" ]
        [ label [ for <| "mce-" ++ values.name ] [ text values.display ]
        , input [ type_ "email", value "", name values.name, id <| "mce-" ++ values.name ] []
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



-- <div class="mc-field-group input-group">
--     <strong>Interests </strong>
--     <ul><li><input type="checkbox" value="1" name="group[76553][1]" id="mce-group[76553]-76553-0"><label for="mce-group[76553]-76553-0">Elm Training</label></li>
-- <li><input type="checkbox" value="2" name="group[76553][2]" id="mce-group[76553]-76553-1"><label for="mce-group[76553]-76553-1">Redux =&gt; Elm</label></li>
-- <li><input type="checkbox" value="4" name="group[76553][4]" id="mce-group[76553]-76553-2"><label for="mce-group[76553]-76553-2">GraphQL and Elm</label></li>
-- </ul>
-- </div>
--
--
--
--
-- 	<div id="mce-responses" class="clear">
-- 		<div class="response" id="mce-error-response" style="display:none"></div>
-- 		<div class="response" id="mce-success-response" style="display:none"></div>
-- 	</div>    <!-- real people should not fill this in and expect good things - do not remove this or risk form bot signups-->
--     <div style="position: absolute; left: -5000px;" aria-hidden="true"><input type="text" name="b_8252abc4ac213a3cdf1832799_c68ad2ba25" tabindex="-1" value=""></div>
--     <div class="clear"><input type="submit" value="Subscribe" name="subscribe" id="mc-embedded-subscribe" class="button"></div>
