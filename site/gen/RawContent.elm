module RawContent exposing (content)

import Content exposing (Content)
import Dict exposing (Dict)
import Element exposing (Element)


content =
    { pages = pages, posts = posts }


pages : List ( List String, String )
pages =
    [
    ( ["accelerator-application"]
      , """|> Article
    title = Accelerator Application
    description = Accelerator Application

|> H2
    🏋️\u{200D}♂️ 📚 Growing Elm Modules - Group Coaching Program

Would you like to develop skills to help you with the following challenges?

|> List
    - What does the process of architecture look like for an in elm?
    - How do know which parts of your elm code to split out and organize together?
    - How do you keep your app easy to change and hard to break as you grow your non-trivial single-page apps?
    - How do you make working with new elm libraries manageable?
    - How can you use types to fix bugs and prevent new bugs?


In my Growing Elm Modules program, you will develop the habits and skills to address these issues head-on. Because the program is structured around group coaching and battle-tested lessons and exercises, the program is relatively high on learning commitment, and relatively low on financial commitment. You'll come away with more than a knowledge dump. You'll come away with real skills and real improvements to your codebase.

You'll learn through several mediums:

|> List
    - Group coaching calls every week
    - Drills to practice core skills
    - Exercises to apply to improve your codebase and get feedback in coaching hours
    - Slack chat with your peers in your program

The program is limited to 5 people, which means you get a good balance of coaching on your specific issues, and learning from other developer's experiences.


If you're interested to learn more, fill out this form and I'll send you a link to schedule a call so we can explore whether this program can help you with your goals.


|> GoogleForm
    1FAIpQLSd7V15KXuoReco2xJzz70LD-d691hQJ-586XNjAmQVSkdYUsQ
"""
      )

  ,( ["accelerator-program"]
      , """|> Article
    title = Elm Accelerator Group Coaching Program
    description = Elm Accelerator Group Coaching Program

|> H1
    Incremental Elm Accelerator Program

This program is designed to help you develop the techniques and habits that get you writing effective elm code without getting stuck. You can only learn so much by reading. You need the right mix of techniques and principles, expert feedback and guidance, and seeing how experts actually write code.

Breaking down the actual steps that elm experts take naturally when they're coding is key to how this program helps you succeed. The videos, exercises, and coaching in this program are designed to demystify the techniques that elm experts use, and guide you through building up those habits to get you writing elm like a pro!

|> H2
    Format

|> List
    - 2 group coaching sessions per month
    - Up to 5 developers per group
    - Exclusive monthly videos
    - Exclusive exercises
    - Private Slack access to share progress and get help
    - You pay for 3 months at a time. $250 x 3 = $750 per quarter
"""
      )

  ,( ["articles"]
      , """|> Article
    title = Articles
    description = Incremental Elm Consulting articles

|> IndexContent
    posts = articles
"""
      )

  ,( ["contact"]
      , """|> Article
    title = Contact
    description = Contact

|> H1
    Contact Incremental Elm

|> Image
    src = contact.jpg
    description = Contact Image

|> ContactButton
"""
      )

  ,( ["core-skills-seminar"]
      , """|> Article
    title = Core Skills Seminar
    description = Core Skills Seminar
|> H2
    🏋️\u{200D}♂️ 📚 Core Skills Seminar

Would you like to develop skills to help you with the following challenges?

|> List
    - What does the process of architecture look like for an in elm?
    - How do know which parts of your elm code to split out and organize together?
    - How do you keep your app easy to change and hard to break as you grow your non-trivial single-page apps?
    - How do you make working with new elm libraries manageable?
    - How can you use types to fix bugs and prevent new bugs?


In my Growing Elm Modules program, you will develop the habits and skills to address these issues head-on. Because the program is structured around group coaching and battle-tested lessons and exercises, the program is relatively high on learning commitment, and relatively low on financial commitment. You'll come away with more than a knowledge dump. You'll come away with real skills and real improvements to your codebase.

You'll learn through several mediums:

|> List
    - Group coaching calls every week
    - Drills to practice core skills
    - Exercises to apply to improve your codebase and get feedback in coaching hours
    - Slack chat with your peers in your program

The program is limited to 5 people, which means you get a good balance of coaching on your specific issues, and learning from other developer's experiences.


If you're interested to learn more, fill out this form and I'll send you a link to schedule a call so we can explore whether this program can help you with your goals.

|> GoogleForm
    1FAIpQLSd7V15KXuoReco2xJzz70LD-d691hQJ-586XNjAmQVSkdYUsQ
"""
      )

  ,( ["custom-scalar-checklist"]
      , """|> Article
    title = Custom Scalar Checklist
    description = Custom Scalar Checklist

|> H1
    How to improve your schema with Custom Scalars

|> H2
    What

Use Custom Scalars instead of GraphQL primitives.

Instead of:

|> Code
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

|> Code
    type Book {
      publicationDate: DateTime!
      price: USD!
      coverImage: CoverImage!
      averageRating: StarRating!
      id: BookId!
    }

|> H2
    When


|> List
    - You want to transform the value into a particular data structure (e.g. Custom Scalar `DateTime`{code} -> Elm `Time`{code})
    - You want to ensure that a value is not mixed up and passed in where it has the same primitive representation but different semantic meaning (for example, `ProductId`{code} and `UserId`{code} might both be Strings, but if they are Custom Scalars then `elm-graphql`{code} can prevent you from passing in the wrong type.
    - You want to control *how* the data is used. For example a `Temperature`{code} or `USD`{code} Custom Scalar has implementation details (perhaps `USD`{code} is represented in cents, but you don't want to leak that knowledge all over your codebase, you want to keep it in one central location).

|> H2
    Why


*Custom Scalars are a way of representing a contract.*

For example, a `DateTime`{code} is just a `String`{code} under the hood. But there is a contract. When I call a value a `DateTime`{code}, I am promising that you will always be able to parse it as an ISO-8601 String (or however it is represented in your API).

The data in your GraphQL response will actually be the same. But by using the `DateTime`{code} Custom Scalar,  you are telling  `elm-graphql`{code} that it is safe to use it in a specific way. In this case, it may be that it can parse it as an ISO-8601 String.

Some other examples would be representing Currency (perhaps `USD`{code}). Again, the underlying representative is just a GraphQL primitive, but you've now given it semantic meaning. And `elm-graphql`{code} is able to take this semantic meaning and turn it into a specific type.

|> H2
    Custom Scalars for Ids


GraphQL provides a type called `Id`{code}. I recommend ignoring this type and instead creating a Custom Scalar to represent each type of Id in your domain. For example `ProductId`{code} or `UserId`{code}.

Why bother?

|> List
    - Nice clear information in the documentation for free
    - Elm can prevent you from passing in a `UserId`{code} where the API requires a `ProductId`{code}

|> H2
    Custom Scalars as Gate Keepers


Custom Scalars also provide a pinch point that allows you to limit all the knowledge about how to use a certain type to a single place. For example, you can use an Opaque Type to make sure that the only way `USD`{code} is displayed is by asking the `USD.elm`{code} module to display it for you. This gives you confidence that the knowledge of how to turn the underlying data representation for `USD`{code} is not leaked throughout your codebase, which reduces bugs and makes it easier to reason about your code.

If you're not using the Custom Scalar Codecs functionality in `elm-graphql`{code}. Take a look at the official [Custom Scalar Codecs example and instructions]{link| url = https://github.com/dillonkearns/elm-graphql/blob/master/examples/src/Example07CustomCodecs.elm }.


Here's an example illustrating this with `USD`{code}.

|> Code
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


|> H1
    The Custom Scalar Checklist



The *Custom Scalar Checklist* guides you through *simple*, *actionable* steps to identify where you should be using Custom Scalars in your schema.

Download it now to get the descriptions and examples of all of these types of fields which should be turned into Custom Scalars:

|> List
    - Unit Contract
    - Format Contract
    - Context Contract
    - Enumeration Contract

|> Signup
    buttonText = Download the checklist
    formId = 573190762
    body =
        |> H1
            ✅ Improve your Schema with this step-by-step checklist

        |> List
            - Simple steps that will improve your elm-graphql codebase!
            - Learn the 4 kinds of Contracts that you can turn into Custom Scalars
"""
      )

  ,( ["elm-graphql-seminar"]
      , """|> Article
    title = Elm GraphQL Seminar
    description = Elm GraphQL Seminar

|> H2
    The Elm GraphQL Seminar

Would you like to leverage elm-graphql best practices to make your codebase more robust? Mastering some core skills and patterns will make writing and maintaining `elm-graphql`{code} code a lot easier. The seminar format allows you to learn from other elm-graphql users' questions and experiences. Plus you'll get help with your specific questions to help you apply elm-graphql best practices where you need them most.

|> List
    - How do you grow your elm-graphql code without creating lots of duplication?
    - How do you use expressive elm types to help you avoid bugs and make code easier to read when you use `elm-graphql`{code}?
    - How do split out and organize your `elm-graphql`{code} queries?
    - What techniques will help improve your GraphQL schema for your elm app?


In the Elm GraphQL seminar, you will develop the habits and skills to address these issues head-on. Because the program is structured around group coaching and battle-tested lessons and exercises, the program is relatively high on learning commitment, and relatively low on financial commitment. You'll come away with more than a knowledge dump. You'll come away with real skills and real improvements to your codebase.

You'll learn through several mediums:

|> List
    - Group coaching calls every week
    - Drills to practice core skills
    - Exercises to apply to improve your codebase and get feedback in coaching hours
    - Slack chat with your peers in your program

The program is limited to 5 people, which means you get a good balance of coaching on your specific issues, and learning from other developer's experiences.


If you're interested to learn more, fill out this form and I'll send you a link to schedule a call so we can explore whether this program can help you with your goals.


|> GoogleForm
    1FAIpQLSdEVtyOcnO-oxtGSathg_LXqWD6ooKHAJc3P58srNtQwUL23Q
"""
      )

  ,( ["elm-graphql-workshop"]
      , """|> Article
    title = Elm GraphQL Workshop
    description = Elm GraphQL Workshop


|> Image
    description = Elm-GraphQL Full-Day Workshop
    src = elm-graphql-workshop-header.jpg

This workshop will equip you with everything you need to make guaranteed-correct, type-safe API requests from your Elm code! And all without needing to write a single JSON Decoder by hand!

In this hands-on workshop, the author of Elm's type-safe GraphQL query builder library, [dillonkearns\\/elm-graphql]{link|url=https://github.com/dillonkearns/elm-graphql}, will walk you through the core concepts and best practices of the library. Check out [Types Without Borders]{link|url=https://www.youtube.com/watch?v=memIRXFSNkU} from the most recent Elm Conf for some of the underlying philosophy of this library. Or you can [read an overview of features of this library]{link|url=https://medium.com/open-graphql/type-safe-composable-graphql-in-elm-b3378cc8d021}. Check out some highlights at the bottom of this event description.

|> H1
    Prerequisites

|> List
    - Understanding of at least Elm basics
    - A computer with a Unix shell and NodeJS

|> H1
    Workshop Format

Over the course of this full-day workshop, we will cover everything from core GraphQL concepts, to the Elm-GraphQL library fundamentals, and finally advanced elm-graphql techniques.



*Morning (1st Half)*


|> List
    1. GraphQL core concepts overview
    1. Elm GraphQL Overview
    1. Making your first GraphQL query
    1. Get it compiling, then get it right
    1. Using your editor to help you build queries quickly
    1. Combining fields together
    1. Basics of modularizing queries - using Elm constructs instead of GraphQL Variables
    1. Mapping into meaningful data structures
    1. Pipelines versus map2, map3..., functions
    1. Advanced techniques for modularizing your API requests in Elm

*Afternoon (2nd Half)*

|> List
    1. Handling polymorphic types (Interfaces and Unions)
    1. Handling errors
    1. Getting real-time data using Subscriptions
    1. Paginated queries
    1. Dealing with real-world schema flaws
    1. Improving schemas
    1. Schema design strategies
    1. What is the purpose of custom scalars in GraphQL?
    1. Leveraging Scalars in Elm GraphQL
    1. Using custom Elm JSON decoders for your Custom Scalar Codecs
    1. Advanced techniques for modularizing your API requests in Elm

|> H1
    Questions? Feedback?

We'd love to hear from you! Let us know what you think of our workshop agenda. Or [send us an email]{link|url = /contact} and we'll be happy to help! Or ping us in the #graphql channel in the [Elm Slack]{link|url = https://elmlang.herokuapp.com/}.

|> Image
    description = Elm-GraphQL Workshop
    src = oslo-workshop1.jpg
"""
      )

  ,( ["incremental-weekly-unsubscribe"]
      , """|> Article
    title = Incremental Elm Weekly Unsubscribe
    description = Incremental Elm Weekly Unsubscribe

Got it! We won't send you any more weekly tips.
"""
      )

  ,( []
      , """|> Article
    title = Incremental Elm Consulting
    description = How I learned to use elm-markup.

|> H1
    Stop Learning Elm Best Practices */The Hard Way/*

Your team has got the hang of Elm. Now it's time to take it to the next level.

You might want to keep reading if:

|> List
    - You want your team to write elm code faster, and to keep writing it fast as your codebase grows.
    - You want your senior devs to spend their time applying elm best practices, not *figuring them out*.
    - You want expert guidance, proven elm techniques, and battle-tested learning material to level up your elm team and codebase fast.

If you're a do-it-yourself kind of person, look no further! You can level up with my Weekly Mastering Elm Tips right now.

Here are some popular tips you can check out right away.

|> List
    - [How can I write elm code faster, and without getting stuck?]{link|url = /articles/moving-faster-with-tiny-steps}
    - [How can I improve my elm-graphql codebase?]{link|url = /custom-scalar-checklist}

|> Signup
    buttonText = I want weekly elm tips!
    formId = 906002494
    body =
        |> H1
            Tips for Writing Like a Senior Elm Dev
        |> List
            - Go beyond learning what great elm code /looks like/. Learn */how to write it/*.
            - Tips you won't find anywhere else to level up your elm skills

|> H1
    How I can help your team level up

I save your team time by teaching techniques to write elm like an expert. Spoiler alert: the elm experts don't make it look easy by working their brains really hard. They know how to let the elm compiler do its job so they can look smart with minimal effort. And you can learn the skills and principles to build elm apps with fewer bugs and less effort, too.

Learn more about how my [Elm Developer Support Packages]{link| url = /services#developer-support} can save your team time and help you deliver on Elm's promise of insanely reliable, easy to maintain applications. Or check out [my other service offerings]{link| url = /services}.
"""
      )

  ,( ["introducing-custom-scalars-course"]
      , """|> Article
    title = Introducing Custom Scalars to your Codebase
    description = Introducing Custom Scalars to your Codebase

|> H1
    Introducing Custom Scalars to your codebase

I recommend downloading the [Custom Scalar Checklist]{link| url = https://incrementalelm.com/assets/custom-scalar-checklist.pdf } and printing it out or keeping it open as you go through this lesson. The videos below are the steps you'll go through after identifying the fields you want to turn into Custom Scalars from going through the checklist.


|> H2
    Part 0 - Intro to the Scalar Codecs module in elm-graphql


Watch this intro to using `--scalar-codecs <ModuleName>`{code} in `elm-graphql`{code} if you haven't already.

|> Vimeo
    329690102

|> H2
    Part 1 - Benefits of using Custom Scalars

|> Vimeo
    329898472

|> H2
    Part 2 - Introducing the steps

|> Vimeo
    329896387

|> H2
    Part 3 - Executing the steps

|> Vimeo
    329888719
"""
      )

  ,( ["scalar-codecs-tutorial"]
      , """|> Article
    title = elm-graphql - Scalar Codecs Tutorial
    description = elm-graphql - Scalar Codecs Tutorial

|> Vimeo
    329690102


|> H1
    Want to take elm-graphql to the next level?

|> H2
    Download the Custom Scalar Checklist ✅


The *Custom Scalar Checklist* guides you through *simple*, *actionable* steps to identify where you should be using Custom Scalars in your schema.

Download it now to get the descriptions and examples of all of these types of fields which should be turned into Custom Scalars:

|> List
    - Unit Contract
    - Format Contract
    - Context Contract
    - Enumeration Contract

|> Signup
    buttonText = Download the checklist
    formId = 573190762
    body =
        |> H1
            ✅ Improve your Schema with this step-by-step checklist

        |> List
            - Simple steps that will improve your elm-graphql codebase!
            - Learn the 4 kinds of Contracts that you can turn into Custom Scalars
"""
      )

  ,( ["services"]
      , """|> Article
    title = Incremental Elm Services
    description = Incremental Elm Services

|> H1
    Incremental Elm Services

|> H2
    🏋️\u{200D}♂️ 📚 Growing Elm Modules - Group Coaching Program

Would you like to develop skills to help you with the following challenges?

|> List
    - What does the process of architecture look like for an in elm?
    - How do know which parts of your elm code to split out and organize together?
    - How do you keep your app easy to change and hard to break as you grow your non-trivial single-page apps?
    - How do you make working with new elm libraries manageable?
    - How can you use types to fix bugs and prevent new bugs?


In my Growing Elm Modules program, you will develop the habits and skills to address these issues head-on. Because the program is structured around group coaching and battle-tested lessons and exercises, the program is relatively high on learning commitment, and relatively low on financial commitment. You'll come away with more than a knowledge dump. You'll come away with real skills and real improvements to your codebase.

You'll learn through several mediums:
|> List
    - Group coaching calls every week
    - Drills to practice core skills
    - Exercises to apply to improve your codebase and get feedback in coaching hours
    - Slack chat with your peers in your program

The program is limited to 5 people, which means you get a good balance of coaching on your specific issues, and learning from other developer's experiences.


If you're interested to learn more, fill out this form and I'll send you a link to schedule a call so we can explore whether this program can help you with your goals.

|> Button
    url = /accelerator-application
    body = Apply for Growing Elm Modules Program

|> Navheader
    id = coaching
    title = 👥 One-on-one Coaching

I offer more personalized guidance that will help you improve your elm app tailored to your specific needs. If you need help with specific challenges you're facing now, this may be a good fit. If you're looking for more general improvement, the group coaching program may be a better value for you.

One-on-one coaching sessions happen on a weekly or bi-weekly basis. Each session has a priority and focus that we decide on beforehand, and ends with a set of next steps. The next steps serve as an action plan to maximize the learning and give you the opportunity to apply the material from the session.

|> Button
    url = https://app.moonclerk.com/pay/59azfo4etnk4
    body = See Coaching Pricing


|> Navheader
    id = training
    title = 🎓 Training

Training packages is a good fit for teams with 4+ Elm engineers. We can arrange to do remote or on-site training depending on your team's needs.

If you have a smaller team, contact me about our public remote workshops.





|> H2
    👋 Contact

Want to discuss finding the right service to help you improve your elm codebase? Send me an email with a brief description of the outcome your looking for.

|> ContactButton

<>
<>
"""
      )

  ,( ["thank-you"]
      , """|> Article
    title = Sign up confirmation
    description = Sign up confirmation
  
|> H1
    Thank you!

|> H2
    Your message is on its way 📪
"""
      )

  ,( ["tips"]
      , """|> Article
    title = Weekly elm Tips!
    description = Weekly elm tips

Here are some popular tips you can check out right away.

|> List
    - [Moving Faster with Tiny Steps in Elm]{link|url = /articles/moving-faster-with-tiny-steps}
    - [Using elm types to prevent logging social security #'s]{link|url = /articles/exit-gatekeepers}

|> H2
    Want more?

I send out practical elm tips every week! 👇

|> Signup
    buttonText = Get weekly elm tips!
    formId = 906002494
    body =
        |> H1
            Get tips to improve your elm code every week

        |> List
            - Go beyond learning what great elm code /looks like/. Learn */how to write it/*.
            - Tips you won't find anywhere else to level up your elm skills
"""
      )

    ]


posts : List ( List String, String )
posts =
    [
    ( ["articles", "exit-gatekeepers"]
      , """|> Article
    title = Using elm types to prevent logging social security #'s
    description = TODO


|> Image
    src = article-cover/exit.jpg
    description = Exit Gatekeepers


One of the most successful techniques I've seen for making sure you don't break elm code the next time you touch it is a technique I call an *Exit Gatekeeper*.

Let's say you have these innocent functions in your app. How do you know that you won't get your wires crossed and log a user's social security number?

|> Code
    securelySaveSSN : String -> Cmd Msg

    reportError : String -> Cmd Msg


You might wrap it in a type wrapper like so:

|> Code
    module SSN exposing (SSN(..))

    type SSN = SSN String

|> Code
    securelySaveSSN : SSN -> Cmd Msg

    reportError : String -> Cmd Msg


The `SSN`{code} type wrapper is a good start. But how do you know it won't be unwrapped and passed around somewhere where it could mistakenly be misused?

|> Code
    storeSSN : SSN -> Cmd Msg
    storeSSN (SSN rawSsn) =
      genericSendData (ssnPayload rawSsn) saveSsnEndpoint

    genericSendData : Json.Encode.Value -> String -> Cmd Msg
    genericSendData payload endpoint =
    -- generic data sending function
    -- if there's an HTTP error, it sends the payload
    -- and error to our error reporting service
    -- ⚠️ Not good for SSNs!

Whoops, somebody forgot that we had a special `securelySaveSSN`{code} function that encrypts the SSN and masks the SSN when reporting errors. Do you dare look at the commit history? It could well have been your past self (we've all been there)!

Humans make mistakes, so let's not expect them to be perfect. The core issue here is that the `SSN`{code} type wrapper has failed to communicate the limits of how we want it to be used. It's merely a convention to use `securelySaveSSN`{code} instead of calling the generic `genericSendData`{code} with the raw String. In this article, you'll learn a technique that gets the elm compiler to help guide us towards using data as intended: Exit Gatekeepers.

|> H2
    🔑 Exit Gatekeepers

So how do we make sure we don't log, Tweet, or otherwise misuse the user's SSN? We control the exits.

There are two ways for the raw data to exit. If raw data exits, then we don't have control over it. So we want to close off these two exit routes.

|> H2
    🔓 Unsecure Exit 1 - Public Constructor

If you expose the constructor, then we can pattern match to get the raw SSN. This means that enforcing the rules for how we want to use SSNs leaks out all over our code instead of being in one central place that we can easily maintain.

|> Code
    -- the (..) exposes the constructor
    module SSN exposing (SSN(..))

|> H2
    🔓 Unsecure Exit 2 - Public Accessor

Similarly, you can unwrap the raw SSN directly from outside the module if we expose an accessor (also known as getters) which returns the /raw data/. In this case, our primitive representation of the SSN is a String, so we could have an unsecure exit by exposing a `toString`{code} accessor.

|> Code
    module SSN exposing (SSN, toString)

    toString : SSN -> String
    toString (SSN rawSsn) = rawSsn

The public accessor function has the same effect as our publicly exposed constructor did, allowing us to accidentally pass the raw data to our `genericSendData`{code}.

|> Code
    storeSsn : SSN -> Cmd Msg
    storeSsn ssn =
      genericSendData (ssnPayload (SSN.toString ssn)) saveSsnEndpoint

|> H2
    The role of a gatekeeper

Think of a Gatekeeper like the Model in Model-View-Controller frameworks. The Model acts as a gatekeeper that ensures the integrity of all persistence in our app. Similarly, our Exit Gatekeeper ensures the integrity of a Domain concept (SSNs in this case) throughout our app.

|> H2
    How to control the exits
To add an Exit Gatekeeper, all we need to do is define every function needed to use SSNs internally within the `SSN`{code} module. And of course, each of those functions is responsible for using it appropriately. (And on the other side of that coin, that means that the calling code is free of that responsibility!).

Let's make a function to securely send an SSN. We need to guarantee that:
|> List
    - The SSN is encrypted using the proper key
    - It is sent to the correct endpoint
    - It is sent with https
    - It is masked before being being sent to our error reporting

We don't want to check for all those things everywhere we call this code every time. We want to be able to make sure the code in this module is good whenever it changes, and then completely trust it from the calling code.

|> Code
    module SSN exposing (SSN)

    securelySendSsn : Ssn -> Http.Request
    securelySendSsn ssn =
      Http.post
        { url = "https://yoursecuresite.com/secure-endpoint"
        , body = encryptedSsnBody ssn,
        , expect = ...
        }

Now we can be confident that the calling code will never mistakenly send SSNs to the wrong endpoint, or forget to encrypt them!

|> H2
    Displaying the SSN
What if you only want to display the last 4 digits of the SSN? How do you make sure that you, your team members, and your future self all remember to do that?

You could vigilantly put that in a code review checklist, or come up with all sorts of creative heuristics to avoid that mistake. I like to reach for the Exit Gatekeeper pattern as my first choice. Then you need to check very carefully any time you are modifying the SSN module itself, and you can trust the module and treat it as a blackbox when you're not modifying it.

It's very likely that you'll miss something if you have to think about where SSNs are used throughout your codebase. But it's quite manageable to keep the entire SSN module in your head and feel confident that you're not forgetting anything important.

Here's a simple implementation of our last 4 digits view:

|> Code
    module SSN exposing (SSN)

    lastFourView : SSN -> Html msg
    lastFourView ssn =
      Html.text ("xxx-xx-" ++ lastFour ssn)



|> Signup
    buttonText = I want weekly elm tips!
    formId = 906002494
    body =
        |> H1
            Tips for Writing Like a Senior Elm Dev
        |> List
            - Go beyond learning what great elm code /looks like/. Learn */how to write it/*.
            - Tips you won't find anywhere else to level up your elm skills

|> H2
    Takeaways
You can start applying the Exit Gatekeeper pattern to your elm code right away!

Here are some steps you can apply:

|> List
    1. Notice some data in your codebase that you have to be careful to use safely or correctly
    1. Wrap it in a Custom Type (if you haven't already)
    1. Expose the constructor at first to make the change small and manageable
    1. Get everything compiling and committed!
    1. One by one, copy each function that is consuming your new Custom Type and call it from the new module
    1. Once that's done, you can now hide the constructor, and you now have a proper Exit Gatekeeper for your type!
"""
      )

  ,( ["articles", "moving-faster-with-tiny-steps"]
      , """|> Article
    title = Moving Faster with Tiny Steps in Elm
    description =
        How I learned to use elm-markup.

|> Image
    src = article-cover/mountains.jpg
    description = The Elm Architecture


In this post, we're going to be looking up an Article in an Elm Dict, using the tiniest steps possible.

Why use tiny steps? Simple! Because we want to write Elm code faster, and with more precise error messages to guide us through each step.

|> H2
    Setting Up Your Environment

The point of taking tiny steps is that you get constant, clear feedback. So before I walk through the steps, here are some things to set up in your editor to help you get more feedback:

|> List
    - See Elm compiler errors instantly without manually running a command. For example, have elm-make run whenever your files change. Or run elm-live, webpack, or parcel in watch mode.
    - Even better, get error messages in your editor whenever you save. Here are some instructions for configuring Atom with in-editor compiler errors.
    - Note that with both of these workflows, I recommend saving constantly so you get instant error messages.
    - Atom also gives you auto-completion, which is another helpful form of feedback. Elm-IntelliJ is another good option for this.

|> H2
    The Problem

We're doing a simple blog page that looks up articles based on the URL. We've already got the wiring to get the article name from the URL (for example, localhost:8000\\/article\\/`articlePath`{code}). Now we just need to take that `articlePath`{code} and use it to look up the title and body of our article in a Dict.

|> H2
    The Tiny Steps

If you'd like to see a short video of each of these steps, or download the code so you can try them for yourself, just sign up here and I'll send you a link.

Okay, now let's walk through our tiny steps for building our Dict!

|> H2
    Step 0

Always respond with "Article Not Found."

We start with the failure case because it's easiest. This is sort of like returning 1 for for factorial(1). It's just an easy way to get something working and compiling. Think of this as our "base case".


|> Code
    view : Maybe String -> Browser.Document msg
    view maybeArticlePath =
        articleNotFoundDocument

    articleNotFoundDocument : Browser.Document msg
    articleNotFoundDocument =
        { title = "Article Not Found"
        , body = [ text "Article not found..." ]
        }

We've wired up our code so that when the user visits mysite.com/article/hello, you'll see our "Article Not Found" page.

|> H2
    Step 1

Hard code an empty dictionary.

|> Code
    view : Maybe String -> Browser.Document msg
    view maybeArticlePath =
        Dict.get articlePath Dict.empty
            |> Maybe.map articleDocument
            |> Maybe.withDefault articleNotFoundDocument

Why bother? We know this lookup will always give back Nothing! So we haven't changed the behavior at all.

This step is actually quite powerful. We've wired up our entire pipeline to reliably do a dictionary lookup and get back Nothing every time! Why is this so useful? Well, look at what we accomplish with this easy step:

We've made the necessary imports
We know that all the puzzle pieces fit perfectly together!
So even though we've done almost nothing, the work that remains is all teed up for us! This is the power of incremental steps. We've stripped out all the risk because we know that the whole picture ties together correctly.

When you mix in the hard part (building the actual business logic) with the "easy part" (the wiring), you end up with something super hard! But when you do the wiring first, you can completely focus on the hard part once that's done. And amazingly, this small change in our approach makes it a lot easier.

|> H2
    Step 2

Extract the dictionary to a top-level value.

|> Code
    view : Maybe String -> Browser.Document msg
    view maybeArticlePath =
        Dict.get articlePath articles
            |> Maybe.map articleDocument
            |> Maybe.withDefault articleNotFoundDocument

    articles =
        Dict.empty

This is just a simple refactor. We can refactor at any step. This is more than a superficial change, though. Pulling out this top-level value allows us to continue tweaking this small area inside a sort of sandbox. This will be much easier with a type-annotation, though…

|> H2
    Step 3
Annotate our articles top-level value.

|> Code
    view : Maybe String -> Browser.Document msg
    view maybeArticlePath =
        Dict.get articlePath articles
            |> Maybe.map articleDocument
            |> Maybe.withDefault articleNotFoundDocument

    articles : Dict String Article
    articles =
        Dict.empty

This step is important because it allows the Elm compiler to give us more precise and helpful error messages. It can now pinpoint exactly where things go wrong if we take a misstep. Importantly, we're locking in the type annotation at a time when everything compiles already so we know things line up. If we added the type annotation when things weren't fully compiling, we wouldn't be very confident that we got it right.

|> H2
    Step 4

Use a "synonym" for Dict.empty.

|> Code
    articles : Dict String Article
    articles =
        Dict.fromList []

What's a synonym? Well, it's just a different way to say the exact same thing.

Kent Beck calls this process "Make the change easy, then make the easy change." Again, this is all about teeing ourselves up to make the next step trivial.

|> H2
    Step 5

Add a single item to your dictionary

|> Code
    Dict.fromList
        [ ( "hello"
          , { title = "Hello!", body = "Here's a nice article for you! 🎉" }
          )
        ]

Now that we've done all those other steps, this was super easy! We know exactly what this data structure needs to look like in order to get the type of data we need, because we've already wired it up! And when we finally wire it up, everything just flows through uneventfully. Perhaps it's a bit anti-climactic, but hey, it's effective!

But isn't this just a toy example to illustrate a technique. While this technique is very powerful when it comes to more sophisticated problems, trust me when I say this is how I write code all the time, even when it's as trivial as creating a dictionary. And I promise you, having this technique in your tool belt will make it easier to write Elm code!

|> H2
    Step 6
In this example, we were dealing with hardcoded data. But it's easy to imagine grabbing this list from a database or an API. I'll leave this as an exercise for the reader, but let's explore the benefits.

When you start with small steps, removing hard-coding step by step, it lets you think up front about the ideal data structure. This ideal data structure dictates your code, and then from there you figure out how to massage the data from your API into the right data structure. It's easy to do things the other way around and let our JSON structures dictate how we're storing the data on the client.

|> H2
    Thanks for Reading!

You can sign up here for more tips on writing Elm code incrementally. When you sign up, I'll send the 3-minute walk-through video of each of these steps, and the download link for the starting-point code and the solution.

Let me know how this technique goes! I've gotten a lot of great feedback from my clients about this approach, and I love hearing success stories. I'd love to hear how you're able to apply this in your day-to-day work!
"""
      )

  ,( ["articles", "to-test-or-not-to-test"]
      , """|> Article
    title = To test, or not to test elm code?
    description =
        How I learned to use elm-markup.

|> Image
    src = article-cover/thinker.jpg
    description = Cover

That... is the question Richard Feldman's keynote at Elm in the Spring last week explored. Richard talked about the interplay between unit tests and the elm type system. His general advice is the same as I've described it:

|> H2
    "In elm, you only test your business logic."

In other words, in the context of a JavaScript app, you have to be really careful to test wiring, and in many ways you have to emulate the role of a type system in your tests.

So a JavaScript//Ruby//other untyped test suite may include checks for:

|> List
    - Does it give an error if you pass an unwanted type as an argument?
    - Does it ever return null when it shouldn't?
    - Does it ever enter into an "Impossible State"

|> H2
    What to test in elm?

So is it as simple as that in elm? You don't need to unit test your wiring, impossible states, or constraints expressed in your types (e.g. non-nullable)?

Yes, I think it is that simple! It's important to understand some context first, though. You can write your code in such a way that it doesn't really seem like business logic. Because the business logic gets buried, so it seems like something else.

It's common for wiring code to get intimately intertwined with core business logic. For example, you can have a view helper function that knows about how to display currency, or how to apply a discount code to a product. So do you test the view code in order to make sure your business logic is correct?


|> H2
    Flip it around

Instead of testing the business logic that's accessible to test in your code, make the business accessible and test it.

|> List
    - Keep all your interesting business logic decoupled from wiring and display logic
    - Given your nice, independent business logic modules, write unit tests for those.

|> Signup
    buttonText = I want weekly elm tips!
    formId = 906002494
    body =
        |> H1
            Tips for Writing Like a Senior Elm Dev
        |> List
            - Go beyond learning what great elm code /looks like/. Learn */how to write it/*.
            - Tips you won't find anywhere else to level up your elm skills

|> H2
    Test-first guides you to decouple business logic

Writing unit tests before versus after writing your implementation is fundamentally different. One of the core benefits of Test-Driven Development is that it guides you to keep your business logic decoupled from your wiring and view logic. Because you're writing tests first, you will naturally write testable code, since you're thinking about how to test it */before/* you think about how to implement it.
"""
      )

  ,( ["learn", "getting-started"]
      , """|> Article
    title = Getting Started Resources
    description = Getting Started Resources


Here are my favorite resources for learning the Elm fundamentals.

|> Resource
    title = The Official Elm Guide
    url = https://guide.elm-lang.org/
    icon = Article

Learn the fundamentals from Evan Czaplicki, the creator of Elm. It's pretty concise, I recommend going through it when you first start with Elm!

|> Resource
    title = Making Impossible States Impossible
    url = https://www.youtube.com/watch?v=IcgmSRJHu_8
    icon = Video

Once Elm beginners have learned the basic Elm syntax, the next stumbling block I see is often learning to write idiomatic Elm code. Idiomatic Elm code uses Custom Types, which are much more expressive than the types most languages have (if they are typed at all). This 20-minute video teaches you how to use types to eliminate corner-cases at compile-time!

|> Resource
    title = Elm in Action
    url = https://www.manning.com/books/elm-in-action
    icon = Book

If you want to thoroughly master the fundamentals, I highly recommend working through this book!

|> Resource
    title = The Elm Slack
    url = https://elmlang.herokuapp.com
    icon = App

This is a great place to get help when you're starting out, there are lots of friendly people in #beginners.
"""
      )

    ]
