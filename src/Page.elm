module Page exposing (Page, all, parseMarkup, view)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import MarkParser


type alias Page =
    { title : String
    , body : String
    , url : String
    }


all : List { body : String, title : String, url : String }
all =
    [ { title = "Incremental Elm Consulting - About"
      , url = ""
      , body =
            """| Header
    Stop Learning Elm Best Practices */The Hard Way/*

Your team has got the hang of Elm. Now it's time to take it to the next level.

You might want to keep reading if:

| List
    - You want your team to write elm code faster, and to keep writing it fast as your codebase grows.
    - You want your senior devs to spend their time applying elm best practices, not *figuring them out*.
    - You want expert guidance, proven elm techniques, and battle-tested learning material to level up your elm team and codebase fast.

If you're a do-it-yourself kind of person, look no further! You can level up with my Weekly Mastering Elm Tips right now.

Here are some popular tips you can check out right away.
| List
    - {Link|How can I write elm code faster, and without getting stuck?|url = /learn/moving-faster-with-tiny-steps}
    - {Link|How can I improve my elm-graphql codebase?|url = /custom-scalar-checklist}

| Signup
    I want weekly elm tips!
    | Header
        Tips for Writing Like a Senior Elm Dev
    | List
        - Go beyond learning what great elm code /looks like/. Learn */how to write it/*.
        - Tips you won't find anywhere else to level up your elm skills

| Header
    How I can help your team level up

I save your team time by teaching techniques to write elm like an expert. Spoiler alert: the elm experts don't make it look easy by working their brains really hard. They know how to let the elm compiler do its job so they can look smart with minimal effort. And you can learn the skills and principles to build elm apps with fewer bugs and less effort, too.

Learn more about how my {Link|Elm Developer Support Packages | url = /services#developer-support} can save your team time and help you deliver on Elm's promise of insanely reliable, easy to maintain applications. Or check out {Link|my other service offerings| url = /services}."""
      }
    , { title = "Contact Incremental Elm"
      , url = "contact2"
      , body = """| Header
    Contact Incremental Elm

| Image
    src = /assets/contact.jpg
    description = Contact Image

| ContactButton

"""
      }
    , { title = "Elm Accelerator Group Coaching Program"
      , url = "accelerator-program"
      , body = """| Header
    Incremental Elm Accelerator Program

This program is designed to help you develop the techniques and habits that get you writing effective elm code without getting stuck. You can only learn so much by reading. You need the right mix of techniques and principles, expert feedback and guidance, and seeing how experts actually write code.

Breaking down the actual steps that elm experts take naturally when they're coding is key to how this program helps you succeed. The videos, exercises, and coaching in this program are designed to demysitify the techniques that elm experts use, and guide you through building up those habits to get you writing elm like a pro!

| Subheader
    Format

| List
    - 2 group coaching sessions per month
    - Up to 5 developers per group
    - Exclusive monthly videos
    - Exclusive exercises
    - Private Slack access to share progress and get help
    - You pay for 3 months at a time. $250 x 3 = $750 per quarter
"""
      }
    , { title = "How to Improve Your Schema"
      , url = "custom-scalar-checklist"
      , body =
            """| Header
    How to improve your schema with Custom Scalars

| Subheader
    What

Use Custom Scalars instead of GraphQL primitives.

Instead of:

| Monospace
    type Book {
      publicationDate: String!

      # cover assets are stored at
      # `/covers/<coverImage>?format=<large|small>`
      coverImage: String!

      averageRating: Float!
      id: String!
    }

Try using Custom Scalars like this:
| Monospace
    type Book {
      publicationDate: DateTime!
      coverImage: CoverImage!
      averageRating: StarRating!
      id: BookId!
    }

| Subheader
    When

| List
    - You want to transform the value into a particular data structure (e.g. Custom Scalar {Code|DateTime} -> Elm {Code|Time})
    - You want to ensure that a value is not mixed up and passed in where it has the same primitive representation but different semantic meaning (for example, {Code|ProductId} and {Code|UserId} might both be Strings, but if they are Custom Scalars then {Code|elm-graphql} can prevent you from passing in the wrong type.
    - You want to control *how* the data is used. For example a {Code|Temperature} or {Code|USD} Custom Scalar has implementation details (perhaps {Code|USD} is represented in cents, but you don't want to leak that knowledge all over your codebase, you want to keep it in one central location).

| Subheader
    Why

*Custom Scalars are a way of representing a contract.*

For example, a {Code|DateTime} is just a {Code|String} under the hood. But there is a contract. When I call a value a {Code|DateTime}, I am promising that you will always be able to parse it as an ISO-8601 String (or however it is represented in your API).

The data in your GraphQL response will actually be the same. But by using the {Code|DateTime} Custom Scalar,  you are telling  {Code|elm-graphql} that it is safe to use it in a specific way. In this case, it may be that it can parse it as an ISO-8601 String.

Some other examples would be representing Currency (perhaps {Code|USD}). Again, the underlying representative is just a GraphQL primitive, but you've now given it semantic meaning. And {Code|elm-graphql} is able to take this semantic meaning and turn it into a specific type.

| Subheader
    Custom Scalars for Ids

GraphQL provides a type called {Code|Id}. I recommend ignoring this type and instead creating a Custom Scalar to represent each type of Id in your domain. For example {Code|ProductId} or {Code|UserId}.

Why bother?
| List
    - Nice clear information in the documentation for free
    - Elm can prevent you from passing in a {Code|UserId} where the API requires a {Code|ProductId}

| Subheader
    Custom Scalars as Gate Keepers

Custom Scalars also provide a pinch point that allows you to limit all the knowledge about how to use a certain type to a single place. For example, you can use an Opaque Type to make sure that the only way {Code|USD} is displayed is by asking the {Code|USD.elm} module to display it for you. This gives you confidence that the knowledge of how to turn the underlying data representation for {Code|USD} is not leaked throughout your codebase, which reduces bugs and makes it easier to reason about your code.

If you're not using the Custom Scalar Codecs functionality in {Code|elm-graphql}. Take a look at the official {Link|Custom Scalar Codecs example and instructions | url = https://github.com/dillonkearns/elm-graphql/blob/master/examples/src/Example07CustomCodecs.elm
 }.

Here's an example illustrating this with {Code|USD}.

| Monospace
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


| Header
    The Custom Scalar Checklist


The *Custom Scalar Checklist* guides you through *simple*, *actionable* steps to identify where you should be using Custom Scalars in your schema.

Download it now to get the descriptions and examples of all of these types of fields which should be turned into Custom Scalars:

| List
    - Unit Contract
    - Format Contract
    - Context Contract
    - Enumeration Contract

| Signup
    Download the checklist
    | Header
        ✅ Improve your Schema with this step-by-step checklist
    | List
        - Simple steps that will improve your elm-graphql codebase!
        - Learn the 4 kinds of Contracts that you can turn into Custom Scalars
"""
      }
    , { title = "Incremental Elm Services"
      , url = "services"
      , body = """| Header
    Incremental Elm Services

| Subheader
    Elm Developer Support Packages

All Elm Developer Support include:

| List
    - Incremental Elm Slack access
    - Email support
    - Member-only learning content
    - Member-only webinars

Any of the packages except Basic includes your choice of one of these services when you sign up for a half year or more:

| List
    - Elm-GraphQL Audit - get advice on where you could improve your data modeling for your GraphQL Schema, or improve your elm code for your {Code|elm-graphql} queries.
    - Elm-GraphQL Setup - We'll get the initial set up all wired in for hitting your GraphQL API using {Code|elm-graphql}.

The packages are:

| List
    - Basic program (2 monthly Developer Support sessions)
    - Unlimited {Code|elm-graphql} Developer Support
    - Unlimited Elm Developer Support Calls
    - Code Reviews & Coaching Bundle

All Developer Support Calls are 30-60 minutes long. To make sure our sessions are as effective as possible, we will define the goal before each call, and you will receive action items and followup notes//resources after each call.

Each is billed quarterly.

| Subheader
    Coaching Days

| List
    - {Code|elm-graphql} Setup - get the entire setup in place for calling {Code|GraphQL} from your Elm app
    - Full-Day Pairing

| Subheader
    Training

Training packages is a good fit for teams with 4+ Elm engineers. We can arrange to do remote or on-site training depending on your team's needs.

If you have a smaller team, contact us about our public remote workshops."""
      }
    , { title = "Incremental Elm Weekly Unsubscribe"
      , body = "Got it! We won't send you any more weekly tips."
      , url = "incremental-weekly-unsubscribe"
      }
    , { title = "Elm GraphQL Workshop"
      , body = """| Image
    description = Elm-GraphQL Full-Day Workshop
    src = /assets/elm-graphql-workshop-header.jpg

This workshop will equip you with everything you need to make guaranteed-correct, type-safe API requests from your Elm code! And all without needing to write a single JSON Decoder by hand!

In this hands-on workshop, the author of Elm's type-safe GraphQL query builder library, {Link|dillonkearns\\/elm-graphql|url=https://github.com/dillonkearns/elm-graphql}, will walk you through the core concepts and best practices of the library. Check out {Link|Types Without Borders|url=https://www.youtube.com/watch?v=memIRXFSNkU} from the most recent Elm Conf for some of the underlying philosophy of this library. Or you can {Link|read an overview of features of this library|url=https://medium.com/open-graphql/type-safe-composable-graphql-in-elm-b3378cc8d021}. Check out some highlights at the bottom of this event description.

| Header
    Prerequisites

| List
    - Understanding of at least Elm basics
    - A computer with a Unix shell and NodeJS

| Header
    Workshop Format

Over the course of this full-day workshop, we will cover everything from core GraphQL concepts, to the Elm-GraphQL library fundamentals, and finally advanced elm-graphql techniques.



*Morning (1st Half)*


| List
    #. GraphQL core concepts overview
    #. Elm GraphQL Overview
    #. Making your first GraphQL query
    #. Get it compiling, then get it right
    #. Using your editor to help you build queries quickly
    #. Combining fields together
    #. Basics of modularizing queries - using Elm constructs instead of GraphQL Variables
    #. Mapping into meaningful data structures
    #. Pipelines versus map2, map3..., functions
    #. Advanced techniques for modularizing your API requests in Elm

*Afternoon (2nd Half)*

| List
    #. Handling polymorphic types (Interfaces and Unions)
    #. Handling errors
    #. Getting real-time data using Subscriptions
    #. Paginated queries
    #. Dealing with real-world schema flaws
    #. Improving schemas
    #. Schema design strategies
    #. What is the purpose of custom scalars in GraphQL?
    #. Leveraging Scalars in Elm GraphQL
    #. Using custom Elm JSON decoders for your Custom Scalar Codecs
    #. Advanced techniques for modularizing your API requests in Elm

| Header
    Questions? Feedback?

We'd love to hear from you! Let us know what you think of our workshop agenda. Or {Link|send us an email|url = /contact} and we'll be happy to help! Or ping us in the #graphql channel in the {Link|Elm Slack|url = https://elmlang.herokuapp.com/}.

| Image
    description = Elm-GraphQL Workshop
    src = /assets/oslo-workshop1.jpg
"""
      , url = "elm-graphql-workshop"
      }
    , { url = "architecture"
      , title = "The Elm Architecture"
      , body =
            """| Image
    src = /assets/architecture.jpg
    description = The Elm Architecture


| Ellie
    3xfc59cYsd6a1

| Header
    Further Reading and Exercises

| Resources
    | Resource
        title = Architecture section of The Official Elm Guide
        url = https://guide.elm-lang.org/architecture/
        icon = Article
    | Resource
        title = Add a -1 button to the Ellie example
        url = https://ellie-app.com/3xfc59cYsd6a1
        icon = Exercise
"""
      }
    ]


view : Page -> Dimensions -> Element msg
view page dimensions =
    page.body
        |> parseMarkup
        |> Element.el
            [ if Dimensions.isMobile dimensions then
                Element.width (Element.fill |> Element.maximum 600)

              else
                Element.width Element.fill
            , Element.height Element.fill
            , if Dimensions.isMobile dimensions then
                Element.padding 20

              else
                Element.paddingXY 200 50
            , Element.spacing 30
            ]


parseMarkup : String -> Element msg
parseMarkup markup =
    markup
        |> MarkParser.parse []
        |> (\result ->
                case result of
                    Err message ->
                        Element.text "Couldn't parse!\n"

                    Ok element ->
                        element identity
           )
