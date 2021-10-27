module Page.Page_ exposing (BackRef, Data, Model, Msg, PageMetadata, RouteParams, page)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Date exposing (Date)
import Fauna.Mutation
import Fauna.Object.Views
import Graphql.Http
import Graphql.Operation exposing (RootMutation)
import Graphql.SelectionSet exposing (SelectionSet)
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Link
import Markdown.Block as Block exposing (Block)
import Markdown.Parser
import MarkdownCodec
import OptimizedDecoder as Decode exposing (Decoder)
import Page exposing (Page, PageWithState, StaticPayload)
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
import TailwindMarkdownRenderer2
import Time
import Timestamps exposing (Timestamps)
import UnsplashImage exposing (UnsplashImage)
import View exposing (View)


hitsForPath : String -> SelectionSet Int RootMutation
hitsForPath path =
    Fauna.Mutation.viewPath
        { path = path
        }
        Fauna.Object.Views.hits


getViewCount : RouteParams -> Cmd Msg
getViewCount routeParams =
    let
        selection =
            hitsForPath (Route.toPath (Route.Page_ routeParams) |> Path.toAbsolute)
    in
    selection
        |> Graphql.Http.mutationRequest "https://graphql.us.fauna.com/graphql"
        |> Graphql.Http.withHeader "authorization" "Bearer fnAEWjYIVjAASOb7tn1P4EkEY4hUXnKyqw6kenuA"
        |> Graphql.Http.send GotViewCount


type alias Model =
    { views : Maybe Int
    }


type Msg
    = GotViewCount (Result (Graphql.Http.Error Int) Int)


type alias RouteParams =
    { page : String }


page : PageWithState RouteParams Data Model Msg
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildWithLocalState
            { view = view
            , update =
                \_ _ _ _ msg model ->
                    case msg of
                        GotViewCount (Ok viewCount) ->
                            ( { model | views = Just viewCount }, Cmd.none )

                        GotViewCount _ ->
                            ( { model | views = Nothing }, Cmd.none )
            , subscriptions = \_ _ _ _ -> Sub.none
            , init = \_ _ static -> ( { views = Nothing }, getViewCount static.routeParams )
            }


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


type alias Metadata =
    { cover : Maybe UnsplashImage
    , publishedAt : Maybe Date
    }


type alias Data =
    { metadata : Metadata
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


formatDate : Date -> String
formatDate =
    Date.format "MMMM dd, y"


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel model static =
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
                            (\note ->
                                case static.data.metadata.publishedAt of
                                    Just publishDate ->
                                        text <| "Published " ++ formatDate publishDate

                                    Nothing ->
                                        let
                                            asDate : Date
                                            asDate =
                                                note.timestamps.created |> Date.fromPosix Time.utc
                                        in
                                        text <|
                                            "Created "
                                                ++ (note.timestamps.created
                                                        |> Date.fromPosix Time.utc
                                                        |> formatDate
                                                   )
                            )
                        ]
                    , div []
                        [ viewIf static.data.noteData
                            (\note ->
                                let
                                    publishedOrCreatedDate =
                                        static.data.metadata.publishedAt
                                            |> Maybe.withDefault
                                                (note.timestamps.created
                                                    |> Date.fromPosix Time.utc
                                                )
                                in
                                if publishedOrCreatedDate == (note.timestamps.updated |> Date.fromPosix Time.utc) then
                                    text ""

                                else
                                    text <|
                                        "Updated "
                                            ++ (note.timestamps.updated
                                                    |> Date.fromPosix Time.utc
                                                    |> formatDate
                                               )
                            )
                        ]
                    , viewIf model.views
                        (\views ->
                            text <| String.fromInt views ++ " views"
                        )
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
                static.data.metadata.cover
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


type alias PageMetadata =
    { description : Maybe String
    , image : Maybe UnsplashImage
    }


decoder : Decoder Metadata
decoder =
    Decode.map2 Metadata
        (Decode.optionalField "cover" UnsplashImage.decoder)
        (Decode.optionalField
            "publishAt"
            (Decode.string
                |> Decode.andThen
                    (\isoString ->
                        case Date.fromIsoString isoString of
                            Ok date ->
                                Decode.succeed date

                            Err error ->
                                Decode.fail error
                    )
            )
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


isWikiLink : String -> Bool
isWikiLink destination =
    not (destination |> String.startsWith "http")
