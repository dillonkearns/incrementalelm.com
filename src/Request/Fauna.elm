module Request.Fauna exposing (dataSource, mutation, query)

import DataSource exposing (DataSource)
import DataSource.Http
import Graphql.Document
import Graphql.Http
import Graphql.Operation exposing (RootMutation, RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Encode as Encode


query : (Result (Graphql.Http.Error decodesTo) decodesTo -> msg) -> SelectionSet decodesTo RootQuery -> Cmd msg
query toMsg selection =
    selection
        |> Graphql.Http.queryRequest faunaUrl
        |> Graphql.Http.withHeader "authorization" faunaAuthValue
        |> Graphql.Http.send toMsg


mutation : (Result (Graphql.Http.Error decodesTo) decodesTo -> msg) -> SelectionSet decodesTo RootMutation -> Cmd msg
mutation toMsg selection =
    selection
        |> Graphql.Http.mutationRequest faunaUrl
        |> Graphql.Http.withHeader "authorization" faunaAuthValue
        |> Graphql.Http.send toMsg


dataSource : SelectionSet value RootQuery -> DataSource value
dataSource selectionSet =
    DataSource.Http.request
        { url = faunaUrl
        , method = "POST"
        , headers = [ ( "authorization", faunaAuthValue ) ]
        , body =
            DataSource.Http.jsonBody
                (Encode.object
                    [ ( "query"
                      , selectionSet
                            |> Graphql.Document.serializeQuery
                            |> Encode.string
                      )
                    ]
                )
        }
        (selectionSet
            |> Graphql.Document.decoder
            |> DataSource.Http.expectJson
        )


faunaUrl =
    "https://graphql.us.fauna.com/graphql"


faunaAuthValue =
    "Bearer fnAEWjYIVjAASOb7tn1P4EkEY4hUXnKyqw6kenuA"
