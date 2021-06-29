module Page.Page_ exposing (BackRef, Data, Model, Msg, PageMetadata, RouteParams, page)

import Css
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
import Route exposing (Route)
import Serialize
import Shared
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


data : RouteParams -> DataSource Data
data routeParams =
    let
        filePath : String
        filePath =
            Debug.log "filePath" ("content/" ++ routeParams.page ++ ".md")
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
             , [ backReferencesView static.data.backReferences
               , backReferencesView static.data.forwardReferences
               ]
             ]
                |> List.concat
            )
    }


backReferencesView : List BackRef -> Html msg
backReferencesView backRefs =
    if List.isEmpty backRefs then
        text ""

    else
        div
            []
            [ h2
                [ css
                    [ Css.fontFamilies [ "Raleway" ]
                    , Tw.text_2xl
                    , Tw.font_bold
                    , Tw.pb_4
                    ]
                ]
                [ text "Linked References" ]
            , ul
                [ css [ Css.fontFamilies [ "Open Sans" ] ]
                ]
                (backRefs
                    |> List.map
                        (\backReference ->
                            li
                                []
                                [ Route.Page_ { page = backReference.slug }
                                    |> Link.htmlLink [] (text backReference.title)
                                ]
                        )
                )
            ]


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
    { slug : String, title : String }


notes : DataSource (List BackRef)
notes =
    Glob.succeed
        (\topic filePath ->
            MarkdownCodec.noteTitle filePath
                |> DataSource.map
                    (BackRef topic)
        )
        |> Glob.match (Glob.literal "content/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.captureFilePath
        |> Glob.toDataSource
        |> DataSource.resolve


backReferences : String -> DataSource (List BackRef)
backReferences slug =
    notes
        |> DataSource.map
            (\allNotes ->
                allNotes
                    |> List.map
                        (\note ->
                            DataSource.File.bodyWithoutFrontmatter ("content/" ++ note.slug ++ ".md")
                                |> DataSource.andThen
                                    (\rawMarkdown ->
                                        rawMarkdown
                                            |> Markdown.Parser.parse
                                            |> Result.map
                                                (\blocks ->
                                                    if hasReferenceTo slug blocks then
                                                        Just note

                                                    else
                                                        Nothing
                                                )
                                            |> Result.mapError (\_ -> "Markdown error")
                                            |> DataSource.fromResult
                                    )
                        )
            )
        |> DataSource.resolve
        |> DataSource.map (List.filterMap identity)
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
                    |> DataSource.distillSerializeCodec "forwardRefs" (Serialize.list serializeBackRef)
            )


serializeBackRef : Serialize.Codec e { slug : String, title : String }
serializeBackRef =
    Serialize.record BackRef
        |> Serialize.field .slug Serialize.string
        |> Serialize.field .title Serialize.string
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


forwardReferences : List Block -> List BackRef
forwardReferences blocks =
    blocks
        |> Block.inlineFoldl
            (\inline links ->
                case inline of
                    Block.Link str _ _ ->
                        if isWikiLink str then
                            { slug = str
                            , title =
                                -- TODO real title, not slug
                                str
                            }
                                :: links

                        else
                            links

                    _ ->
                        links
            )
            []


isWikiLink destination =
    not (destination |> String.startsWith "http")
