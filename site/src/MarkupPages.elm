module MarkupPages exposing (program)

import Browser
import Browser.Navigation
import Content exposing (Content)
import Dict exposing (Dict)
import Element exposing (Element)
import Json.Decode
import MarkParser
import Platform.Sub exposing (Sub)
import RawContent
import Url exposing (Url)


type alias Program userFlags userModel userMsg =
    Platform.Program (Flags userFlags) (Model userModel) (Msg userMsg)


mainView :
    (userModel -> MarkParser.PageOrPost userMsg -> { title : String, body : Element userMsg })
    -> Model userModel
    -> { title : String, body : Element userMsg }
mainView pageOrPostView (Model model) =
    case RawContent.content model.imageAssets of
        Ok site ->
            pageView pageOrPostView (Model model) site

        Err errorView ->
            { title = "Error parsing"
            , body = errorView
            }


pageView :
    (userModel -> MarkParser.PageOrPost msg -> { title : String, body : Element msg })
    -> Model userModel
    -> Content msg
    -> { title : String, body : Element msg }
pageView pageOrPostView (Model model) content =
    case Content.lookup content model.url of
        Just pageOrPost ->
            pageOrPostView model.userModel pageOrPost

        Nothing ->
            { title = "Page not found"
            , body =
                Element.column []
                    [ Element.text "Page not found. Valid routes:\n\n"
                    , (content.pages ++ content.posts)
                        |> List.map Tuple.first
                        |> List.map (String.join "/")
                        |> String.join ", "
                        |> Element.text
                    ]
            }


view :
    (userModel -> MarkParser.PageOrPost userMsg -> { title : String, body : Element userMsg })
    -> Model userModel
    -> Browser.Document (Msg userMsg)
view pageOrPostView model =
    let
        { title, body } =
            mainView pageOrPostView model
    in
    { title = title
    , body =
        [ body
            |> Element.map UserMsg
            |> Element.layout
                [ Element.width Element.fill
                ]
        ]
    }


type alias Flags userFlags =
    { userFlags
        | imageAssets : Json.Decode.Value
    }


init :
    (Flags userFlags -> ( userModel, Cmd userMsg ))
    -> Flags userFlags
    -> Url
    -> Browser.Navigation.Key
    -> ( Model userModel, Cmd (Msg userMsg) )
init initUserModel flags url key =
    let
        ( userModel, userCmd ) =
            initUserModel flags
    in
    ( Model
        { key = key
        , url = url
        , imageAssets =
            Json.Decode.decodeValue
                (Json.Decode.dict Json.Decode.string)
                flags.imageAssets
                |> Result.withDefault Dict.empty
        , userModel = userModel
        }
    , userCmd |> Cmd.map UserMsg
    )


type Msg userMsg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | UserMsg userMsg


type Model userModel
    = Model
        { key : Browser.Navigation.Key
        , url : Url.Url
        , imageAssets : Dict String String
        , userModel : userModel
        }


update :
    (userMsg -> userModel -> ( userModel, Cmd userMsg ))
    -> Msg userMsg
    -> Model userModel
    -> ( Model userModel, Cmd (Msg userMsg) )
update userUpdate msg (Model model) =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( Model model, Browser.Navigation.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( Model model, Browser.Navigation.load href )

        UrlChanged url ->
            ( Model { model | url = url }
            , Cmd.none
            )

        UserMsg userMsg ->
            let
                ( userModel, userCmd ) =
                    userUpdate userMsg model.userModel
            in
            ( Model { model | userModel = userModel }, userCmd |> Cmd.map UserMsg )


program :
    { init : Flags userFlags -> ( userModel, Cmd userMsg )
    , update : userMsg -> userModel -> ( userModel, Cmd userMsg )
    , subscriptions : Sub userMsg
    , view : userModel -> MarkParser.PageOrPost userMsg -> { title : String, body : Element userMsg }
    }
    -> Program userFlags userModel userMsg
program config =
    Browser.application
        { init = init config.init
        , view = view config.view
        , update = update config.update
        , subscriptions = \_ -> Sub.none --config.subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }
