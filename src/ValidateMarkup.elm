port module ValidateMarkup exposing (main)

import Mark
import MarkParser
import Page.Learn
import Page.Learn.Post exposing (Post)


port showMarkupError : String -> Cmd msg


port success : () -> Cmd msg


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( ()
    , case markupResult of
        Ok () ->
            success ()

        Err errorContext ->
            showMarkupError errorContext
    )


markupResult : Result String ()
markupResult =
    case markupErrors of
        [] ->
            Ok ()

        errors ->
            Err (errors |> String.join "\n\n")


markupErrors : List String
markupErrors =
    Page.Learn.all
        |> List.filterMap
            (\post ->
                case post.body |> Mark.parse MarkParser.document of
                    Err error ->
                        String.join "\n"
                            [ post.pageName
                            , error |> Debug.toString
                            ]
                            |> Just

                    Ok _ ->
                        Nothing
            )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type Msg
    = NoOp


type alias Model =
    ()


type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }
