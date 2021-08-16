module Page.Page_ exposing (BackRef, Data, Model, Msg, PageMetadata, RouteParams, page)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Link
import Markdown.Block as Block exposing (Block)
import Markdown.Parser
import MarkdownCodec
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Regex
import Route exposing (Route)
import Serialize
import Shared
import String.Extra
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import TailwindMarkdownRenderer2
import Timestamps exposing (Timestamps)
import UnsplashImage exposing (UnsplashImage)
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { page : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    Glob.succeed RouteParams
        |> Glob.match (Glob.literal "content/")
        |> Glob.match (Glob.oneOf ( ( "page/", () ), [ ( "", () ) ] ))
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource
        |> DataSource.map
            (List.filter
                (\value -> value.page /= "index")
            )


type PageKind
    = Page
    | NotePage


findFilePath : String -> DataSource ( String, PageKind )
findFilePath slug =
    Glob.succeed Tuple.pair
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/")
        |> Glob.capture (Glob.oneOf ( ( "page/", Page ), [ ( "", NotePage ) ] ))
        |> Glob.match (Glob.literal slug)
        |> Glob.match (Glob.literal ".md")
        |> Glob.expectUniqueMatch


data : RouteParams -> DataSource Data
data routeParams =
    findFilePath routeParams.page
        |> DataSource.andThen
            (\( filePath, pageKind ) ->
                case pageKind of
                    NotePage ->
                        DataSource.map3
                            Data
                            (DataSource.File.onlyFrontmatter decoder filePath)
                            (MarkdownCodec.withoutFrontmatter TailwindMarkdownRenderer2.renderer filePath
                                |> DataSource.resolve
                            )
                            (MarkdownCodec.titleAndDescription filePath)
                            |> DataSource.andMap
                                (DataSource.map3 NoteRecord
                                    (backReferences routeParams.page)
                                    (forwardRefs routeParams.page)
                                    (Timestamps.data filePath)
                                    |> DataSource.map Just
                                )

                    Page ->
                        DataSource.map3
                            Data
                            (DataSource.File.onlyFrontmatter decoder filePath)
                            (MarkdownCodec.withoutFrontmatter TailwindMarkdownRenderer2.renderer filePath
                                |> DataSource.resolve
                            )
                            (MarkdownCodec.titleAndDescription filePath)
                            |> DataSource.andMap (DataSource.succeed Nothing)
            )


type alias Data =
    { cover : Maybe UnsplashImage
    , body : List (Html Msg)
    , info : { title : String, description : String }
    , noteData : Maybe NoteRecord
    }


type alias CommonData =
    { metadata : PageMetadata
    , body : List (Html Msg)
    , title : String
    }


type alias NoteRecord =
    { backReferences : List BackRef
    , forwardReferences : List BackRef
    , timestamps : Timestamps
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.info.title
    , body =
        View.Tailwind
            ([ [ div
                    [ css
                        [ Tw.text_xs
                        ]
                    ]
                    [ div
                        []
                        [ viewIf static.data.noteData
                            (\note -> text <| "Created " ++ Timestamps.format note.timestamps.created)
                        ]
                    , div []
                        [ viewIf static.data.noteData
                            (\note -> text <| "Updated " ++ Timestamps.format note.timestamps.updated)
                        ]
                    ]
               ]
             , static.data.body
             , [ viewIf static.data.noteData
                    (\note ->
                        div
                            [ css
                                []
                            ]
                            [ backReferencesView "Notes that link here" note.backReferences
                            , backReferencesView "Links on this page" note.forwardReferences
                            ]
                    )
               ]
             ]
                |> List.concat
            )
    }


viewIf : Maybe a -> (a -> Html msg) -> Html msg
viewIf maybeData dataToView =
    Maybe.map dataToView maybeData
        |> Maybe.withDefault (text "")


backReferencesView : String -> List BackRef -> Html msg
backReferencesView title backRefs =
    if List.isEmpty backRefs then
        text ""

    else
        div []
            [ h2 [] [ text title ]
            , backReferencesView_ backRefs
            ]


backReferencesView_ : List BackRef -> Html msg
backReferencesView_ allBackRefs =
    div
        [ css
            [ Tw.mt_12
            , Tw.max_w_lg
            , Tw.mx_auto
            , Tw.grid
            , Tw.gap_5
            , Bp.lg
                [ Tw.grid_cols_2
                , Tw.max_w_none
                ]
            ]
        ]
        (allBackRefs
            |> List.map
                (\backReference ->
                    blogCard (Route.Page_ { page = backReference.slug }) backReference
                )
        )


blogCard : Route -> { a | title : String, description : String } -> Html msg
blogCard route info =
    route
        |> Link.htmlLink
            [ css
                [ Tw.flex
                , Tw.flex_col
                , Tw.rounded_lg
                , Tw.shadow_lg
                , Tw.overflow_hidden
                ]
            ]
            (div
                [ css
                    [ Tw.flex_1
                    , Tw.bg_white
                    , Tw.p_6
                    , Tw.flex
                    , Tw.flex_col
                    , Tw.justify_between
                    ]
                ]
                [ div
                    [ css
                        [ Tw.flex_1
                        ]
                    ]
                    [ span
                        [ css
                            [ Tw.block
                            , Tw.mt_2
                            ]
                        ]
                        [ p
                            [ css
                                [ Tw.text_xl
                                , Tw.font_semibold
                                , Tw.text_gray_900
                                ]
                            ]
                            [ text info.title ]
                        , p
                            [ css
                                [ Tw.mt_3
                                , Tw.text_base
                                , Tw.text_gray_500
                                ]
                            ]
                            [ info.description
                                |> String.Extra.softEllipsis 160
                                |> text
                            ]
                        ]
                    ]
                ]
            )


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summaryLarge
        { canonicalUrlOverride = Nothing
        , siteName = "Incremental Elm"
        , image =
            { url =
                static.data.cover
                    |> Maybe.withDefault UnsplashImage.default
                    |> UnsplashImage.rawUrl
                    |> Pages.Url.external
            , alt = static.data.info.title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = static.data.info.description
        , title = static.data.info.title
        , locale = Nothing
        }
        |> Seo.website



--[]


type alias PageMetadata =
    { description : Maybe String
    , image : Maybe UnsplashImage
    }


decoder : Decoder (Maybe UnsplashImage)
decoder =
    Decode.optionalField "cover" UnsplashImage.decoder


type alias Note =
    { route : Route
    , slug : String
    , title : String
    }


type alias BackRef =
    { slug : String
    , title : String
    , description : String
    }


notes : DataSource (List { topic : String, filePath : String })
notes =
    Glob.succeed
        (\topic filePath -> { topic = topic, filePath = filePath })
        |> Glob.match (Glob.literal "content/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.captureFilePath
        |> Glob.toDataSource
        |> DataSource.map (List.filter (\value -> value.topic /= "index"))


backReferences : String -> DataSource (List BackRef)
backReferences slug =
    notes
        |> DataSource.andThen
            (\allNotes ->
                allNotes
                    |> List.map
                        (\note ->
                            DataSource.File.bodyWithoutFrontmatter ("content/" ++ note.topic ++ ".md")
                                |> DataSource.andThen
                                    (\rawMarkdown ->
                                        rawMarkdown
                                            |> Markdown.Parser.parse
                                            |> Result.map
                                                (\blocks ->
                                                    if hasReferenceTo slug blocks then
                                                        MarkdownCodec.titleAndDescription note.filePath
                                                            |> DataSource.map
                                                                (\{ title, description } -> BackRef note.topic title description)
                                                            |> Just

                                                    else
                                                        Nothing
                                                )
                                            |> Result.mapError (\_ -> "Markdown error")
                                            |> DataSource.fromResult
                                    )
                        )
                    |> DataSource.combine
                    |> DataSource.map (List.filterMap identity)
                    |> DataSource.resolve
            )
        |> DataSource.distillSerializeCodec "backrefs" (Serialize.list serializeBackRef)


forwardRefs : String -> DataSource (List BackRef)
forwardRefs slug =
    DataSource.File.bodyWithoutFrontmatter ("content/" ++ slug ++ ".md")
        |> DataSource.andThen
            (\rawMarkdown ->
                rawMarkdown
                    |> Markdown.Parser.parse
                    |> Result.map
                        (\blocks ->
                            blocks
                                |> forwardReferences
                        )
                    |> Result.mapError (\_ -> "Markdown error")
                    |> DataSource.fromResult
                    |> DataSource.resolve
            )
        |> DataSource.distillSerializeCodec "forwardRefs" (Serialize.list serializeBackRef)


serializeBackRef : Serialize.Codec e BackRef
serializeBackRef =
    Serialize.record BackRef
        |> Serialize.field .slug Serialize.string
        |> Serialize.field .title Serialize.string
        |> Serialize.field .description Serialize.string
        |> Serialize.finishRecord


hasReferenceTo : String -> List Block -> Bool
hasReferenceTo slug blocks =
    blocks
        |> Block.inlineFoldl
            (\inline links ->
                case inline of
                    Block.Link str _ _ ->
                        if str == slug then
                            True

                        else
                            links

                    _ ->
                        links
            )
            False


forwardReferences : List Block -> List (DataSource BackRef)
forwardReferences blocks =
    blocks
        |> Block.inlineFoldl
            (\inline links ->
                case inline of
                    Block.Link rawSlug _ _ ->
                        let
                            slug =
                                rawSlug
                                    |> Regex.replace (Regex.fromString "^/" |> Maybe.withDefault Regex.never) (\_ -> "")
                                    |> Regex.replace (Regex.fromString "/$" |> Maybe.withDefault Regex.never) (\_ -> "")
                                    |> Regex.replace (Regex.fromString "#.*" |> Maybe.withDefault Regex.never) (\_ -> "")
                        in
                        if isWikiLink slug then
                            (MarkdownCodec.titleAndDescription ("content/" ++ slug ++ ".md")
                                |> DataSource.map
                                    (\{ title, description } -> BackRef slug title description)
                            )
                                :: links

                        else
                            links

                    _ ->
                        links
            )
            []


isWikiLink destination =
    not (destination |> String.startsWith "http")
