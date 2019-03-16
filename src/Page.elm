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
      , url = "new"
      , body =
            """| Header
    Stop Learning Elm Best Practices */The Hard Way/*

Your team has got the hang of Elm. Now it's time to take it to the next level.

You might want to keep reading if:

| List
    - You want your senior devs to spend their time applying elm best practices, not *figuring them out*.
    - You want expert guidance, proven elm techniques, and battle-tested learning material to level up your elm team and codebase fast.
    - You want your team to write elm code faster, and to keep writing it fast as your codebase grows.

If you're a do-it-yourself kind of person, look no further! You can level up with my Weekly Mastering Elm Tips right now.

Here are some popular tips you can check out right away.

| List
    - {Link|How can I write elm code faster, and without getting stuck?|url = /learn/moving-faster-with-tiny-steps}
    - {Link|Are types good enough, or should I write unit tests for my Elm code?|url = /learn/moving-faster-with-tiny-steps}


Send me more elm tips every week



You have some lingering questions like:

| List
    - {Link|How can I write Elm code faster, and without getting stuck?|url = /learn/moving-faster-with-tiny-steps}
    - {Link|Are types good enough, or should I write unit tests for my Elm code?|url = /learn/moving-faster-with-tiny-steps}
    - {Link|How do I organize my Elm app as I scale?| url = asdf.com}
    - {Link|Which libraries and patterns am I missing out on that will take my Elm code to the next level?| url = asdf.com}

| Subheader
    Your Senior Devs Are Distracted Trying to Master Elm Instead of Focusing on Building Your App

How much time do your senior devs have to learn all the elm best practices? How much time do you want to spend going down a dead-end path only to learn that you have to backtrack to?

We save your engineering team time by teaching techniques to write elm like an expert. Spoiler alert: the elm experts don't make it look easy by working their brains really hard. They know how to let the elm compiler do its job so they can look smart with minimal effort. And you can learn the skills and principles to build elm apps with fewer bugs and less effort, too.

Learn more about how Incremental Elm can help your team level up and write elm like experts.

Learn more about how our {Link|Elm Developer Support Packages | url = /services#developer-support} can save your team time and help you deliver on Elm's promise of insanely reliable, easy to maintain applications.

{Link|>> Services | url = /services}

Or check out my free Incremental Elm Tips to learn the tricks that Elm Masters use intuitively to speed through building up Elm code with ease.

Give your team lead a break from researching "the best way to do X in Elm", and preparing learning sessions on the basics for the rest of the team. That's what we're here for! We can get your team "thinking in Elm" with our tested teaching techniques and expert guidance.
"""
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
    - Member only webinars

The packages are:

| List
    - Basic program (2 monthly Developer Support sessions)
    - Unlimited {Code|elm-graphql} Developer Support
    - Unlimited Elm Coaching Calls
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
