---
{
    "type": "page",
    "title": "Custom Scalar Checklist"
}
---

# How to improve your schema with Custom Scalars

## What

Use Custom Scalars instead of GraphQL primitives.

Instead of:

```
type Book {
    publicationDate: String!
    priceInCents: Int!

    # cover assets are stored at
    # `/covers/<coverImage>?format=<large|small>`
    coverImage: String!

    averageRating: Float!
    id: String!
}
```

Try using Custom Scalars like this:

```
type Book {
    publicationDate: DateTime!
    price: USD!
    coverImage: CoverImage!
    averageRating: StarRating!
    id: BookId!
}
```

## When

- You want to transform the value into a particular data structure (e.g. Custom Scalar `DateTime` -> Elm `Time`)
- You want to ensure that a value is not mixed up and passed in where it has the same primitive representation but different semantic meaning (for example, `ProductId` and `UserId` might both be Strings, but if they are Custom Scalars then `elm-graphql` can prevent you from passing in the wrong type.
- You want to control *how* the data is used. For example a `Temperature` or `USD` Custom Scalar has implementation details (perhaps `USD` is represented in cents, but you don't want to leak that knowledge all over your codebase, you want to keep it in one central location).

## Why

**Custom Scalars are a way of representing a contract.**

For example, a `DateTime` is just a `String` under the hood. But there is a contract. When I call a value a `DateTime`, I am promising that you will always be able to parse it as an ISO-8601 String (or however it is represented in your API).

The data in your GraphQL response will actually be the same. But by using the `DateTime` Custom Scalar,  you are telling  `elm-graphql` that it is safe to use it in a specific way. In this case, it may be that it can parse it as an ISO-8601 String.

Some other examples would be representing Currency (perhaps `USD`). Again, the underlying representative is just a GraphQL primitive, but you've now given it semantic meaning. And `elm-graphql` is able to take this semantic meaning and turn it into a specific type.

## Custom Scalars for Ids


GraphQL provides a type called `Id`. I recommend ignoring this type and instead creating a Custom Scalar to represent each type of Id in your domain. For example `ProductId` or `UserId`.

Why bother?

- Nice clear information in the documentation for free
- Elm can prevent you from passing in a `UserId` where the API requires a `ProductId`

## Custom Scalars as Gate Keepers

Custom Scalars also provide a pinch point that allows you to limit all the knowledge about how to use a certain type to a single place. For example, you can use an Opaque Type to make sure that the only way `USD` is displayed is by asking the `USD.elm` module to display it for you. This gives you confidence that the knowledge of how to turn the underlying data representation for `USD` is not leaked throughout your codebase, which reduces bugs and makes it easier to reason about your code.

If you're not using the Custom Scalar Codecs functionality in `elm-graphql`. Take a look at the official [Custom Scalar Codecs example and instructions](https://github.com/dillonkearns/elm-graphql/blob/master/examples/src/Example07CustomCodecs.elm).


Here's an example illustrating this with `USD`.

```elm
module USD exposing (USD, codec, toString)


import Graphql.Codec exposing (Codec)
import Json.Decode exposing (Decoder)
import Json.Encode


type USD
    = Dollars Int


codec : Codec USD
codec =
    { encoder = encode
    , decoder = decoder
    }


decoder : Decoder USD
decoder =
    Json.Decode.map Dollars Json.Decode.int


encode : USD -> Json.Encode.Value
encode (Dollars  dollars) =
    Json.Encode.int dollars


toString : USD -> String
toString (Dollars  dollars ) =
    "$" ++ String.fromInt dollars
```


# The Custom Scalar Checklist


The **Custom Scalar Checklist** guides you through **simple**, **actionable** steps to identify where you should be using Custom Scalars in your schema.

Download it now to get the descriptions and examples of all of these types of fields which should be turned into Custom Scalars:

- Unit Contract
- Format Contract
- Context Contract
- Enumeration Contract

<Signup buttonText="Download the checklist" formId="573190762">
# ✅ Improve your Schema with this step-by-step checklist

- Simple steps that will improve your elm-graphql codebase!
- Learn the 4 kinds of Contracts that you can turn into Custom Scalars
</Signup>
