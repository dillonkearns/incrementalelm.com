module Page.Page_ exposing (BackRef, Data, Model, Msg, PageMetadata, RouteParams, page)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Head
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
import Path
import Regex
import Route exposing (Route)
import Serialize
import Shared
import String.Extra
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw
import TailwindMarkdownRenderer
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
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource
        |> DataSource.map
            (List.filter
                (\value -> value.page /= "index")
            )


data : RouteParams -> DataSource Data
data routeParams =
    let
        filePath : String
        filePath =
            "content/" ++ routeParams.page ++ ".md"
    in
    DataSource.map5
        Data
        (DataSource.File.onlyFrontmatter decoder filePath)
        (MarkdownCodec.withoutFrontmatter TailwindMarkdownRenderer.renderer filePath)
        (MarkdownCodec.noteTitle filePath)
        (backReferences routeParams.page)
        (forwardRefs routeParams.page)


type alias Data =
    { metadata : PageMetadata
    , body : List (Html Msg)
    , title : String
    , backReferences : List BackRef
    , forwardReferences : List BackRef
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.title
    , body =
        View.Tailwind
            ([ static.data.body
             , [ div
                    [ css
                        []
                    ]
                    [ backReferencesView "Notes that link here" static.data.backReferences
                    , backReferencesView "Links on this page" static.data.forwardReferences
                    ]
               ]
             ]
                |> List.concat
            )
    }


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
    --Seo.summaryLarge
    --    { canonicalUrlOverride = Nothing
    --    , siteName = "Incremental Elm"
    --    , image =
    --        { url = static.data.metadata.image |> Maybe.withDefault (Pages.Url.external "")
    --        , alt = static.data.title
    --        , dimensions = Nothing
    --        , mimeType = Nothing
    --        }
    --    , description = static.data.metadata.description |> Maybe.withDefault static.data.title
    --    , title = static.data.title
    --    , locale = Nothing
    --    }
    --    |> Seo.website
    []


type alias PageMetadata =
    { description : Maybe String
    , image : Maybe Pages.Url.Url
    }


decoder : Decoder PageMetadata
decoder =
    Decode.map2 PageMetadata
        (Decode.maybe (Decode.field "description" Decode.string))
        (Decode.maybe (Decode.field "image" imageDecoder))


imageDecoder : Decoder Pages.Url.Url
imageDecoder =
    Decode.string
        |> Decode.map
            (\src ->
                [ "images", src ]
                    |> Path.join
                    |> Pages.Url.fromPath
            )


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
                    |> DataSource.distillSerializeCodec "forwardRefs" (Serialize.list serializeBackRef)
            )


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
