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
    [ { title = "Accelerator Application"
      , url = "accelerator-application"
      , body = """| Subheader
    🏋️\u{200D}♂️ 📚 Growing Elm Modules - Group Coaching Program

Would you like to develop skills to help you with the following challenges?

| List
    - What does the process of architecture look like for an in elm?
    - How do know which parts of your elm code to split out and organize together?
    - How do you keep your app easy to change and hard to break as you grow your non-trivial single-page apps?
    - How do you make working with new elm libraries manageable?
    - How can you use types to fix bugs and prevent new bugs?


In my Growing Elm Modules program, you will develop the habits and skills to address these issues head-on. Because the program is structured around group coaching and battle-tested lessons and exercises, the program is relatively high on learning commitment, and relatively low on financial commitment. You'll come away with more than a knowledge dump. You'll come away with real skills and real improvements to your codebase.

You'll learn through several mediums:
| List
    - Group coaching calls every week
    - Drills to practice core skills
    - Exercises to apply to improve your codebase and get feedback in coaching hours
    - Slack chat with your peers in your program

The program is limited to 5 people, which means you get a good balance of coaching on your specific issues, and learning from other developer's experiences.


If you're interested to learn more, fill out this form and I'll send you a link to schedule a call so we can explore whether this program can help you with your goals.

<>
  
| GoogleForm
    1FAIpQLSd7V15KXuoReco2xJzz70LD-d691hQJ-586XNjAmQVSkdYUsQ

"""
      }
    , { title = "Incremental Elm Training - About"
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
    | Config
        buttonText = I want weekly elm tips!
        formId = 863568508
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
    , { title = "Sign up confirmation"
      , url = "thank-you"
      , body = """| Header
    Thank you!
| Subheader
    Your message is on its way 📪"""
      }
    , { title = "Weekly elm Tips!"
      , url = "tips"
      , body = """| Signup
    | Config
        buttonText = Get weekly elm tips!
        formId = 573190762
    | Header
        Get tips in your inbox every week
    | List
        - Simple steps that will improve your elm-graphql codebase!
        - Learn the 4 kinds of Contracts that you can turn into Custom Scalars

"""
      }
    , { title = "Exit Checks"
      , url = "exit-checks"
      , body = """| Header
    Avoid tweeting social security #'s using elm types

One of the most successful techniques I've seen for making sure you don't break elm code the next time you touch it is a technique I call an Exit Check.

Let's start by taking this primitive String representation:

| Monospace
    type Msg
      = StoreSSN String
      | LogMessage String


And wrapping it in a simple Custom Type.

By the way, in my mailing list I introduce a technique called a *Type Bouncer* that gives you confidence that the value you have actually represents a real SSN. You can signup for free to get that tip and many more like it!

| Signup
    | Config
        buttonText = Get more elm tips!
        formId = 573190762
    | Header
        Learn about the Type Bouncer technique and other elm tips!
    | List
        - Simple steps that will improve your elm-graphql codebase!
        - Learn the 4 kinds of Contracts that you can turn into Custom Scalars


You can subscribe here to get more tips like this one!

| Monospace
    module SSN exposing (SSN)

    type SSN = SSN String

| Monospace
    type Msg
      = StoreSSN SSN
      | LogMessage String

| Subheader
    Exit Checks

So how do we make sure we don't Tweet, log, or otherwise misuse the user's SSN? We control the exits.

If you expose the constructor, then we can pattern match to get the raw SSN. This means that enforcing the rules for how we want to use SSNs leaks out all over our code instead of being in one central place that we can easily maintain.

| Monospace
    -- the (..) exposes the constructor
    module SSN exposing (SSN(..))


So we can unwrap it from outside of the SSN module:
| Monospace
    case ssn of
      SSN rawSsn -> SendTweet rawSsn

Similarly, you can unwrap the raw SSN directly from outside the module if we expose a {Code|toString}.

| Monospace
    module SSN exposing (SSN, toString)

    toString : SSN -> String
    toString (SSN rawSsn) = rawSsn


| Monospace
    SendTweet (SSN.toString ssn)

Think of an Exit Check like the Model in Model-View-Controller frameworks. The Model acts as a gatekeeper that ensures the integrity of all persistence in our app. Similarly, an Exit Check ensures the integrity of a Domain concept throughout our app.

| Subheader
    Control the Exits
To add an Exit Check, all we need to do is define every function needed to use SSNs internally within the `SSN` module. And of course, each of those functions is responsible for using it appropriately. (And on the other side of that coin, that means that the calling code is free of that responsibility!).

Let's make a function to securely send an SSN. We need to guarantee that:
| List
    - The SSN is encrypted using the proper key
    - It is sent to the correct endpoint
    - It is sent with https

We don't want to check for all those things everywhere we call this code every time. We want to be able to make sure the code in this module is good whenever it changes, and then completely trust it from the calling code.

| Monospace
    module SSN exposing (SSN)

    securelySendSsn : Ssn -> Http.Request
    securelySendSsn ssn =
      Http.post
        { url = "https://yoursecuresite.com/secure-endpoint"
        , body = encryptedSsnBody ssn,
        , expect = ...
        }

Now we can be confident that the calling code will never mistakenly send SSNs to the wrong endpoint, or forget to encrypt them!

| Subheader
    Displaying the SSN
What if you only want to display the last 4 digits of the SSN? How do you make sure that you, your team members, and your future self all remember to do that?

You could vigilantly put that in a code review check list, or come up with all sorts of creative heuristics to avoid that mistake. Or you could use our Exit Check pattern, and check very carefully any time you are modifying the SSN module itself.

It's very likely that you'll miss something if you have to think about where SSNs are used throughout your codebase. But it's quite manageable to keep the entire SSN module in your head and feel confident that you're not forgetting anything important.

Here's a simple implementation of our last 4 digits view:

| Monospace
    module SSN exposing (SSN)

    lastFourView : SSN -> Html msg
    lastFourView ssn =
      Html.text ("xxx-xx-" ++ lastFour ssn)

| Subheader
    Takeaways
You can start applying the Exit Check pattern to your elm code right away!

Here are some steps you can apply:

| List
    #. Notice some data in your codebase that you have to be careful to use safely or correctly
    #. Wrap it in a Custom Type (if you haven't already)
    #. Expose the constructor at first to make the change small and manageable
    #. Get everything compiling and committed!
    #. One by one, copy each function that is consuming your new Custom Type and call it from the new module
    #. Once that's done, you can now hide the constructor, and you now have a proper Exit Check for your type!"""
      }
    , { title = "Introducing Custom Scalars to your Codebase"
      , url = "introducing-custom-scalars-course"
      , body = """| Header
    Introducing Custom Scalars to your codebase

I recommend downloading the {Link|Custom Scalar Checklist | url = https://incrementalelm.com/assets/custom-scalar-checklist.pdf } and printing it out or keeping it open as you go through this lesson. The videos below are the steps you'll go through after identifying the fields you want to turn into Custom Scalars from going through the checklist.


| Subheader
    Part 0 - Intro to the Scalar Codecs module in elm-graphql

Watch this intro to using {Code|--scalar-codecs <ModuleName>} in {Code|elm-graphql} if you haven't already.

| Vimeo
    329690102

| Subheader
    Part 1 - Benefits of using Custom Scalars
| Vimeo
    329898472
| Subheader
    Part 2 - Introducing the steps
| Vimeo
    329896387
| Subheader
    Part 3 - Executing the steps
| Vimeo
    329888719"""
      }
    , { title = "elm-graphql - Scalar Codecs Tutorial"
      , url = "scalar-codecs-tutorial"
      , body = """| Vimeo
    329690102

| Header
    Want to take elm-graphql to the next level?
| Subheader
    Download the Custom Scalar Checklist ✅

The *Custom Scalar Checklist* guides you through *simple*, *actionable* steps to identify where you should be using Custom Scalars in your schema.

Download it now to get the descriptions and examples of all of these types of fields which should be turned into Custom Scalars:

| List
    - Unit Contract
    - Format Contract
    - Context Contract
    - Enumeration Contract

| Signup
    | Config
        buttonText = Download the checklist
        formId = 573190762
    | Header
        ✅ Improve your Schema with this step-by-step checklist
    | List
        - Simple steps that will improve your elm-graphql codebase!
        - Learn the 4 kinds of Contracts that you can turn into Custom Scalars
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
      priceInCents: Int!

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
      price: USD!
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
    | Config
        buttonText = Download the checklist
        formId = 573190762
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
    🏋️\u{200D}♂️ 📚 Growing Elm Modules - Group Coaching Program

Would you like to develop skills to help you with the following challenges?

| List
    - What does the process of architecture look like for an in elm?
    - How do know which parts of your elm code to split out and organize together?
    - How do you keep your app easy to change and hard to break as you grow your non-trivial single-page apps?
    - How do you make working with new elm libraries manageable?
    - How can you use types to fix bugs and prevent new bugs?


In my Growing Elm Modules program, you will develop the habits and skills to address these issues head-on. Because the program is structured around group coaching and battle-tested lessons and exercises, the program is relatively high on learning commitment, and relatively low on financial commitment. You'll come away with more than a knowledge dump. You'll come away with real skills and real improvements to your codebase.

You'll learn through several mediums:
| List
    - Group coaching calls every week
    - Drills to practice core skills
    - Exercises to apply to improve your codebase and get feedback in coaching hours
    - Slack chat with your peers in your program

The program is limited to 5 people, which means you get a good balance of coaching on your specific issues, and learning from other developer's experiences.


If you're interested to learn more, fill out this form and I'll send you a link to schedule a call so we can explore whether this program can help you with your goals.

| Button
    url = /accelerator-application
    body = Apply for Growing Elm Modules Program



| Navheader
    id = training
    title = 🎓 Training

Training packages is a good fit for teams with 4+ Elm engineers. We can arrange to do remote or on-site training depending on your team's needs.

If you have a smaller team, contact me about our public remote workshops.





| Subheader
    👋 Contact

Want to discuss finding the right service to help you improve your elm codebase? Send me an email with a brief description of the outcome your looking for.

| ContactButton

<>
<>
"""
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
