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
import Template.Article
import Template.Glossary
import Template.Learn
import Template.Page
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
    = ModelArticle Template.Article.Model
    | ModelGlossary Template.Glossary.Model
    | ModelLearn Template.Learn.Model
    | ModelPage Template.Page.Model
    | ModelTip Template.Tip.Model

    | NotFound



type Msg
    = MsgGlobal Shared.Msg
    | OnPageChange
        { path : PagePath Pages.PathKey
        , query : Maybe String
        , fragment : Maybe String
        , metadata : TemplateType
        }
    | MsgArticle Template.Article.Msg
    | MsgGlossary Template.Glossary.Msg
    | MsgLearn Template.Learn.Msg
    | MsgPage Template.Page.Msg
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
        M.Article metadata ->
            StaticHttp.map2
                (\data globalData ->
                    { view =
                        \model rendered ->
                            case model.page of
                                ModelArticle subModel ->
                                    Template.Article.template.view
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
                                                        |> Shared.map MsgArticle
                                                    )
                                           )

                                _ ->
                                    { title = "", body = Html.text "" }
                    , head = Template.Article.template.head
                        { static = data
                        , sharedStatic = globalData
                        , metadata = metadata
                        , path = page.path
                        }
                    }
                )
                (Template.Article.template.staticData siteMetadata)
                (Shared.staticData siteMetadata)


        M.Glossary metadata ->
            StaticHttp.map2
                (\data globalData ->
                    { view =
                        \model rendered ->
                            case model.page of
                                ModelGlossary subModel ->
                                    Template.Glossary.template.view
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
                                                        |> Shared.map MsgGlossary
                                                    )
                                           )

                                _ ->
                                    { title = "", body = Html.text "" }
                    , head = Template.Glossary.template.head
                        { static = data
                        , sharedStatic = globalData
                        , metadata = metadata
                        , path = page.path
                        }
                    }
                )
                (Template.Glossary.template.staticData siteMetadata)
                (Shared.staticData siteMetadata)


        M.Learn metadata ->
            StaticHttp.map2
                (\data globalData ->
                    { view =
                        \model rendered ->
                            case model.page of
                                ModelLearn subModel ->
                                    Template.Learn.template.view
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
                                                        |> Shared.map MsgLearn
                                                    )
                                           )

                                _ ->
                                    { title = "", body = Html.text "" }
                    , head = Template.Learn.template.head
                        { static = data
                        , sharedStatic = globalData
                        , metadata = metadata
                        , path = page.path
                        }
                    }
                )
                (Template.Learn.template.staticData siteMetadata)
                (Shared.staticData siteMetadata)


        M.Page metadata ->
            StaticHttp.map2
                (\data globalData ->
                    { view =
                        \model rendered ->
                            case model.page of
                                ModelPage subModel ->
                                    Template.Page.template.view
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
                                                        |> Shared.map MsgPage
                                                    )
                                           )

                                _ ->
                                    { title = "", body = Html.text "" }
                    , head = Template.Page.template.head
                        { static = data
                        , sharedStatic = globalData
                        , metadata = metadata
                        , path = page.path
                        }
                    }
                )
                (Template.Page.template.staticData siteMetadata)
                (Shared.staticData siteMetadata)


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
                        M.Article metadata ->
                            Template.Article.template.init metadata
                                |> Tuple.mapBoth ModelArticle (Cmd.map MsgArticle)


                        M.Glossary metadata ->
                            Template.Glossary.template.init metadata
                                |> Tuple.mapBoth ModelGlossary (Cmd.map MsgGlossary)


                        M.Learn metadata ->
                            Template.Learn.template.init metadata
                                |> Tuple.mapBoth ModelLearn (Cmd.map MsgLearn)


                        M.Page metadata ->
                            Template.Page.template.init metadata
                                |> Tuple.mapBoth ModelPage (Cmd.map MsgPage)


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

        
        MsgArticle msg_ ->
            let
                ( updatedPageModel, pageCmd, ( newGlobalModel, newGlobalCmd ) ) =
                    case ( model.page, model.current |> Maybe.map .metadata ) of
                        ( ModelArticle pageModel, Just (M.Article metadata) ) ->
                            Template.Article.template.update
                                metadata
                                msg_
                                pageModel
                                model.global
                                |> mapBoth ModelArticle (Cmd.map MsgArticle)
                                |> (\( a, b, c ) ->
                                        ( a, b, Shared.update (Shared.SharedMsg c) model.global )
                                   )

                        _ ->
                            ( model.page, Cmd.none, ( model.global, Cmd.none ) )
            in
            ( { model | page = updatedPageModel, global = newGlobalModel }
            , Cmd.batch [ pageCmd, newGlobalCmd |> Cmd.map MsgGlobal ]
            )

        
        MsgGlossary msg_ ->
            let
                ( updatedPageModel, pageCmd, ( newGlobalModel, newGlobalCmd ) ) =
                    case ( model.page, model.current |> Maybe.map .metadata ) of
                        ( ModelGlossary pageModel, Just (M.Glossary metadata) ) ->
                            Template.Glossary.template.update
                                metadata
                                msg_
                                pageModel
                                model.global
                                |> mapBoth ModelGlossary (Cmd.map MsgGlossary)
                                |> (\( a, b, c ) ->
                                        ( a, b, Shared.update (Shared.SharedMsg c) model.global )
                                   )

                        _ ->
                            ( model.page, Cmd.none, ( model.global, Cmd.none ) )
            in
            ( { model | page = updatedPageModel, global = newGlobalModel }
            , Cmd.batch [ pageCmd, newGlobalCmd |> Cmd.map MsgGlobal ]
            )

        
        MsgLearn msg_ ->
            let
                ( updatedPageModel, pageCmd, ( newGlobalModel, newGlobalCmd ) ) =
                    case ( model.page, model.current |> Maybe.map .metadata ) of
                        ( ModelLearn pageModel, Just (M.Learn metadata) ) ->
                            Template.Learn.template.update
                                metadata
                                msg_
                                pageModel
                                model.global
                                |> mapBoth ModelLearn (Cmd.map MsgLearn)
                                |> (\( a, b, c ) ->
                                        ( a, b, Shared.update (Shared.SharedMsg c) model.global )
                                   )

                        _ ->
                            ( model.page, Cmd.none, ( model.global, Cmd.none ) )
            in
            ( { model | page = updatedPageModel, global = newGlobalModel }
            , Cmd.batch [ pageCmd, newGlobalCmd |> Cmd.map MsgGlobal ]
            )

        
        MsgPage msg_ ->
            let
                ( updatedPageModel, pageCmd, ( newGlobalModel, newGlobalCmd ) ) =
                    case ( model.page, model.current |> Maybe.map .metadata ) of
                        ( ModelPage pageModel, Just (M.Page metadata) ) ->
                            Template.Page.template.update
                                metadata
                                msg_
                                pageModel
                                model.global
                                |> mapBoth ModelPage (Cmd.map MsgPage)
                                |> (\( a, b, c ) ->
                                        ( a, b, Shared.update (Shared.SharedMsg c) model.global )
                                   )

                        _ ->
                            ( model.page, Cmd.none, ( model.global, Cmd.none ) )
            in
            ( { model | page = updatedPageModel, global = newGlobalModel }
            , Cmd.batch [ pageCmd, newGlobalCmd |> Cmd.map MsgGlobal ]
            )

        
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
        
        ModelArticle templateModel ->
            case metadata of
                M.Article templateMetadata ->
                    Template.Article.template.subscriptions
                        templateMetadata
                        path
                        templateModel
                        model.global
                        |> Sub.map MsgArticle

                _ ->
                    Sub.none

        
        ModelGlossary templateModel ->
            case metadata of
                M.Glossary templateMetadata ->
                    Template.Glossary.template.subscriptions
                        templateMetadata
                        path
                        templateModel
                        model.global
                        |> Sub.map MsgGlossary

                _ ->
                    Sub.none

        
        ModelLearn templateModel ->
            case metadata of
                M.Learn templateMetadata ->
                    Template.Learn.template.subscriptions
                        templateMetadata
                        path
                        templateModel
                        model.global
                        |> Sub.map MsgLearn

                _ ->
                    Sub.none

        
        ModelPage templateModel ->
            case metadata of
                M.Page templateMetadata ->
                    Template.Page.template.subscriptions
                        templateMetadata
                        path
                        templateModel
                        model.global
                        |> Sub.map MsgPage

                _ ->
                    Sub.none

        
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
