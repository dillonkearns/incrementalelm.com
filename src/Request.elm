module Request exposing (staticGraphqlRequest)

import BackendTask exposing (BackendTask)
import BackendTask.Http
import FatalError exposing (FatalError)
import Graphql.Document
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Encode as Encode


staticGraphqlRequest : SelectionSet value RootQuery -> BackendTask FatalError value
staticGraphqlRequest selectionSet =
    BackendTask.Http.request
        { url = "https://oqagd84p.api.sanity.io/v1/graphql/production/default"
        , method = "POST"
        , headers = []
        , body =
            BackendTask.Http.jsonBody
                (Encode.object
                    [ ( "query"
                      , selectionSet
                            |> Graphql.Document.serializeQuery
                            |> Encode.string
                      )
                    ]
                )
        , retries = Nothing
        , timeoutInMs = Nothing
        }
        (selectionSet
            |> Graphql.Document.decoder
            |> BackendTask.Http.expectJson
        )
        |> BackendTask.allowFatal
