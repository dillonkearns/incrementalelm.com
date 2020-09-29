module TemplateDemultiplexer exposing (..)

import Browser
import Pages.Manifest as Manifest
import Shared
import TemplateType as M exposing (TemplateType)
import Head
import Html exposing (Html)
import Pages
import Pages.PagePath exposing (PagePath)
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import Template.Tip


type alias Model =
    { global : Shared.Model
    , page : TemplateModel
    , current :
        Maybe
            { path :
                { path : PagePath Pages.PathKey
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : TemplateType
            }
    }


type TemplateModel
    = ModelTip Template.Tip.Model

    | NotFound



type Msg
    = MsgGlobal Shared.Msg
    | OnPageChange
        { path : PagePath Pages.PathKey
        , query : Maybe String
        , fragment : Maybe String
        , metadata : TemplateType
        }
    | MsgTip Template.Tip.Msg



view :
    List ( PagePath Pages.PathKey, TemplateType )
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : TemplateType
        }
    ->
        StaticHttp.Request
            { view : Model -> Shared.RenderedBody -> { title : String, body : Html Msg }
            , head : List (Head.Tag Pages.PathKey)
            }
view siteMetadata page =
    case page.frontmatter of
        M.Tip metadata ->
            StaticHttp.map2
                (\data globalData ->
                    { view =
                        \model rendered ->
                            case model.page of
                                ModelTip subModel ->
                                    Template.Tip.template.view
                                        subModel
                                        model.global
                                        siteMetadata
                                        { static = data
                                        , sharedStatic = globalData
                                        , metadata = metadata
                                        , path = page.path
                                        }
                                        rendered
                                        |> (\{ title, body } ->
                                                Shared.view
                                                    globalData
                                                    page
                                                    model.global
                                                    MsgGlobal
                                                    ({ title = title, body = body }
                                                        |> Shared.map MsgTip
                                                    )
                                           )

                                _ ->
                                    { title = "", body = Html.text "" }
                    , head = Template.Tip.template.head
                        { static = data
                        , sharedStatic = globalData
                        , metadata = metadata
                        , path = page.path
                        }
                    }
                )
                (Template.Tip.template.staticData siteMetadata)
                (Shared.staticData siteMetadata)



init :
    Maybe Shared.Model
    ->
        Maybe
            { path :
                { path : PagePath Pages.PathKey
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : TemplateType
            }
    -> ( Model, Cmd Msg )
init currentGlobalModel maybePagePath =
    let
        ( sharedModel, globalCmd ) =
            currentGlobalModel |> Maybe.map (\m -> ( m, Cmd.none )) |> Maybe.withDefault (Shared.init maybePagePath)

        ( templateModel, templateCmd ) =
            case maybePagePath |> Maybe.map .metadata of
                Nothing ->
                    ( NotFound, Cmd.none )

                Just meta ->
                    case meta of
                        M.Tip metadata ->
                            Template.Tip.template.init metadata
                                |> Tuple.mapBoth ModelTip (Cmd.map MsgTip)


    in
    ( { global = sharedModel
      , page = templateModel
      , current = maybePagePath
      }
    , Cmd.batch
        [ templateCmd
        , globalCmd |> Cmd.map MsgGlobal
        ]
    )



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgGlobal msg_ ->
            let
                ( sharedModel, globalCmd ) =
                    Shared.update msg_ model.global
            in
            ( { model | global = sharedModel }
            , globalCmd |> Cmd.map MsgGlobal
            )

        OnPageChange record ->
            init (Just model.global) <|
                Just
                    { path =
                        { path = record.path
                        , query = record.query
                        , fragment = record.fragment
                        }
                    , metadata = record.metadata
                    }

        
        MsgTip msg_ ->
            let
                ( updatedPageModel, pageCmd, ( newGlobalModel, newGlobalCmd ) ) =
                    case ( model.page, model.current |> Maybe.map .metadata ) of
                        ( ModelTip pageModel, Just (M.Tip metadata) ) ->
                            Template.Tip.template.update
                                metadata
                                msg_
                                pageModel
                                model.global
                                |> mapBoth ModelTip (Cmd.map MsgTip)
                                |> (\( a, b, c ) ->
                                        ( a, b, Shared.update (Shared.SharedMsg c) model.global )
                                   )

                        _ ->
                            ( model.page, Cmd.none, ( model.global, Cmd.none ) )
            in
            ( { model | page = updatedPageModel, global = newGlobalModel }
            , Cmd.batch [ pageCmd, newGlobalCmd |> Cmd.map MsgGlobal ]
            )



type alias SiteConfig =
    { canonicalUrl : String
    , manifest : Manifest.Config Pages.PathKey
    }

templateSubscriptions : TemplateType -> PagePath Pages.PathKey -> Model -> Sub Msg
templateSubscriptions metadata path model =
    case model.page of
        
        ModelTip templateModel ->
            case metadata of
                M.Tip templateMetadata ->
                    Template.Tip.template.subscriptions
                        templateMetadata
                        path
                        templateModel
                        model.global
                        |> Sub.map MsgTip

                _ ->
                    Sub.none



        NotFound ->
            Sub.none


mainTemplate { documents, subscriptions, site } =
    Pages.Platform.init
        { init = init Nothing
        , view = view
        , update = update
        , subscriptions =
            \metadata path model ->
                Sub.batch
                    [ subscriptions
                    , templateSubscriptions metadata path model
                    ]
        , documents = documents
        , onPageChange = Just OnPageChange
        , manifest = site.manifest
        , canonicalSiteUrl = site.canonicalUrl
        , internals = Pages.internals
        }



mapDocument : Browser.Document Never -> Browser.Document mapped
mapDocument document =
    { title = document.title
    , body = document.body |> List.map (Html.map never)
    }


mapBoth fnA fnB ( a, b, c ) =
    ( fnA a, fnB b, c )
