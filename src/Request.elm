module Request exposing (staticGraphqlRequest)

import DataSource exposing (DataSource)
import DataSource.Http
import Graphql.Document
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Encode as Encode
import Pages.Secrets as Secrets


staticGraphqlRequest : SelectionSet value RootQuery -> DataSource value
staticGraphqlRequest selectionSet =
    DataSource.Http.unoptimizedRequest
        (Secrets.succeed
            { url = "https://oqagd84p.api.sanity.io/v1/graphql/production/default"
            , method = "POST"
            , headers = []
            , body =
                DataSource.jsonBody
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
            |> DataSource.Http.expectUnoptimizedJson
        )
