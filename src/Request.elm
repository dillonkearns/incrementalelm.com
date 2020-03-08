module Request exposing (staticGraphqlRequest)

import Graphql.Document
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Encode as Encode
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp


staticGraphqlRequest : SelectionSet value RootQuery -> StaticHttp.Request value
staticGraphqlRequest selectionSet =
    StaticHttp.unoptimizedRequest
        (Secrets.succeed
            { url = "https://oqagd84p.api.sanity.io/v1/graphql/production/default"
            , method = "POST"
            , headers = []
            , body =
                StaticHttp.jsonBody
                    (Encode.object
                        [ ( "query"
                          , selectionSet
                                |> Graphql.Document.serializeQuery
                                |> Encode.string
                          )
                        ]
                    )
            }
        )
        (selectionSet
            |> Graphql.Document.decoder
            |> StaticHttp.expectUnoptimizedJson
        )
