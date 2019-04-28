module Page.Article.Post exposing (Post, all)

import Dimensions exposing (Dimensions)
import Element exposing (Element)
import View.Resource as Resource exposing (Resource)


type alias Post =
    { pageName : String
    , title : String
    , body : String
    }


all : List Post
all =
    [ { pageName = "moving-faster-with-tiny-steps"
      , title = "Moving Faster with Tiny Steps in Elm"
      , body =
            """| Image
    src = /assets/mountains.jpg
    description = The Elm Architecture


In this post, we’re going to be looking up an Article in an Elm Dict, using the tiniest steps possible.

Why use tiny steps? Simple! Because we want to write Elm code faster, and with more precise error messages to guide us through each step.

| Subheader
    Setting Up Your Environment

The point of taking tiny steps is that you get constant, clear feedback. So before I walk through the steps, here are some things to set up in your editor to help you get more feedback:

| List
    - See Elm compiler errors instantly without manually running a command. For example, have elm-make run whenever your files change. Or run elm-live, webpack, or parcel in watch mode.
    - Even better, get error messages in your editor whenever you save. Here are some instructions for configuring Atom with in-editor compiler errors.
    - Note that with both of these workflows, I recommend saving constantly so you get instant error messages.
    - Atom also gives you auto-completion, which is another helpful form of feedback. Elm-IntelliJ is another good option for this.
| Subheader
    The Problem

We’re doing a simple blog page that looks up articles based on the URL. We’ve already got the wiring to get the article name from the URL (for example, localhost:8000\\/article\\/{Code|articlePath}). Now we just need to take that {Code|articlePath} and use it to look up the title and body of our article in a Dict.

| Subheader
    The Tiny Steps

If you’d like to see a short video of each of these steps, or download the code so you can try them for yourself, just sign up here and I’ll send you a link.

Okay, now let’s walk through our tiny steps for building our Dict!

| Subheader
    Step 0

Always respond with “Article Not Found.”

We start with the failure case because it’s easiest. This is sort of like returning 1 for for factorial(1). It’s just an easy way to get something working and compiling. Think of this as our “base case”.


| Monospace
    view : Maybe String -> Browser.Document msg
    view maybeArticlePath =
        articleNotFoundDocument

    articleNotFoundDocument : Browser.Document msg
    articleNotFoundDocument =
        { title = "Article Not Found"
        , body = [ text "Article not found..." ]
        }

We’ve wired up our code so that when the user visits mysite.com/article/hello, you’ll see our “Article Not Found” page.

| Subheader
    Step 1

Hard code an empty dictionary.

| Monospace
    view : Maybe String -> Browser.Document msg
    view maybeArticlePath =
        Dict.get articlePath Dict.empty
            |> Maybe.map articleDocument
            |> Maybe.withDefault articleNotFoundDocument

Why bother? We know this lookup will always give back Nothing! So we haven’t changed the behavior at all.

This step is actually quite powerful. We’ve wired up our entire pipeline to reliably do a dictionary lookup and get back Nothing every time! Why is this so useful? Well, look at what we accomplish with this easy step:

We’ve made the necessary imports
We know that all the puzzle pieces fit perfectly together!
So even though we’ve done almost nothing, the work that remains is all teed up for us! This is the power of incremental steps. We’ve stripped out all the risk because we know that the whole picture ties together correctly.

When you mix in the hard part (building the actual business logic) with the “easy part” (the wiring), you end up with something super hard! But when you do the wiring first, you can completely focus on the hard part once that’s done. And amazingly, this small change in our approach makes it a lot easier.

| Subheader
    Step 2

Extract the dictionary to a top-level value.

| Monospace
    view : Maybe String -> Browser.Document msg
    view maybeArticlePath =
        Dict.get articlePath articles
            |> Maybe.map articleDocument
            |> Maybe.withDefault articleNotFoundDocument

    articles =
        Dict.empty

This is just a simple refactor. We can refactor at any step. This is more than a superficial change, though. Pulling out this top-level value allows us to continue tweaking this small area inside a sort of sandbox. This will be much easier with a type-annotation, though…

| Subheader
    Step 3
Annotate our articles top-level value.

| Monospace
    view : Maybe String -> Browser.Document msg
    view maybeArticlePath =
        Dict.get articlePath articles
            |> Maybe.map articleDocument
            |> Maybe.withDefault articleNotFoundDocument

    articles : Dict String Article
    articles =
        Dict.empty

This step is important because it allows the Elm compiler to give us more precise and helpful error messages. It can now pinpoint exactly where things go wrong if we take a misstep. Importantly, we’re locking in the type annotation at a time when everything compiles already so we know things line up. If we added the type annotation when things weren’t fully compiling, we wouldn’t be very confident that we got it right.

| Subheader
    Step 4

Use a "synonym" for Dict.empty.

| Monospace
    articles : Dict String Article
    articles =
        Dict.fromList []

What’s a synonym? Well, it’s just a different way to say the exact same thing.

Kent Beck calls this process “Make the change easy, then make the easy change.” Again, this is all about teeing ourselves up to make the next step trivial.

| Subheader
    Step 5

Add a single item to your dictionary

| Monospace
    Dict.fromList
        [ ( "hello"
          , { title = "Hello!", body = "Here's a nice article for you! 🎉" }
          )
        ]

Now that we’ve done all those other steps, this was super easy! We know exactly what this data structure needs to look like in order to get the type of data we need, because we’ve already wired it up! And when we finally wire it up, everything just flows through uneventfully. Perhaps it’s a bit anti-climactic, but hey, it’s effective!

But isn’t this just a toy example to illustrate a technique. While this technique is very powerful when it comes to more sophisticated problems, trust me when I say this is how I write code all the time, even when it’s as trivial as creating a dictionary. And I promise you, having this technique in your tool belt will make it easier to write Elm code!

| Subheader
    Step 6
In this example, we were dealing with hardcoded data. But it’s easy to imagine grabbing this list from a database or an API. I’ll leave this as an exercise for the reader, but let’s explore the benefits.

When you start with small steps, removing hard-coding step by step, it lets you think up front about the ideal data structure. This ideal data structure dictates your code, and then from there you figure out how to massage the data from your API into the right data structure. It’s easy to do things the other way around and let our JSON structures dictate how we’re storing the data on the client.

| Subheader
    Thanks for Reading!

You can sign up here for more tips on writing Elm code incrementally. When you sign up, I’ll send the 3-minute walk-through video of each of these steps, and the download link for the starting-point code and the solution.

Let me know how this technique goes! I’ve gotten a lot of great feedback from my clients about this approach, and I love hearing success stories. Hit reply and let me know how it goes! I’d love to hear how you’re able to apply this in your day-to-day work!
"""
      }
    , { title = "Using elm types to prevent logging social security #'s"
      , pageName = "exit-gatekeepers"
      , body = """| Image
    src = /assets/article-cover/exit.jpg
    description = Exit Gatekeepers


One of the most successful techniques I've seen for making sure you don't break elm code the next time you touch it is a technique I call an *Exit Gatekeeper*.

Let's say you have these innocent functions in your app. How do you know that you won't get your wires crossed and log a user's social security number?

| Monospace
    securelySaveSSN : String -> Cmd Msg

    reportError : String -> Cmd Msg


You might wrap it in a type wrapper like so:

| Monospace
    module SSN exposing (SSN(..))

    type SSN = SSN String

| Monospace
    securelySaveSSN : SSN -> Cmd Msg

    reportError : String -> Cmd Msg


The {Code|SSN} type wrapper is a good start. But how do you know it won't be unwrapped and passed around somewhere where it could mistakenly be misused?

| Monospace
    storeSSN : SSN -> Cmd Msg
    storeSSN (SSN rawSsn) =
      genericSendData (ssnPayload rawSsn) saveSsnEndpoint

    genericSendData : Json.Encode.Value -> String -> Cmd Msg
    genericSendData payload endpoint =
    -- generic data sending function
    -- if there's an HTTP error, it sends the payload
    -- and error to our error reporting service
    -- ⚠️ Not good for SSNs!

Whoops, somebody forgot that we had a special {Code|securelySaveSSN} function that encrypts the SSN and masks the SSN when reporting errors. Do you dare look at the commit history? It could well have been your past self (we've all been there)!

Humans make mistakes, so let's not expect them to be perfect. The core issue here is that the {Code|SSN} type wrapper has failed to communicate the limits of how we want it to be used. It's merely a convention to use {Code|securelySaveSSN} instead of calling the generic {Code|genericSendData} with the raw String. In this article, you'll learn a technique that gets the elm compiler to help guide us towards using data as intended: Exit Gatekeepers.

| Subheader
    🔑 Exit Gatekeepers

So how do we make sure we don't log, Tweet, or otherwise misuse the user's SSN? We control the exits.

There are two ways for the raw data to exit. If raw data exits, then we don't have control over it. So we want to close off these two exit routes.

| Subheader
    🔓 Unsecure Exit 1 - Public Constructor

If you expose the constructor, then we can pattern match to get the raw SSN. This means that enforcing the rules for how we want to use SSNs leaks out all over our code instead of being in one central place that we can easily maintain.

| Monospace
    -- the (..) exposes the constructor
    module SSN exposing (SSN(..))

| Subheader
    🔓 Unsecure Exit 2 - Public Accessor

Similarly, you can unwrap the raw SSN directly from outside the module if we expose an accessor (also known as getters) which returns the /raw data/. In this case, our primitive representation of the SSN is a String, so we could have an unsecure exit by exposing a {Code|toString} accessor.

| Monospace
    module SSN exposing (SSN, toString)

    toString : SSN -> String
    toString (SSN rawSsn) = rawSsn

The public accessor function has the same effect as our publicly exposed constructor did, allowing us to accidentally pass the raw data to our {Code|genericSendData}.

| Monospace
    storeSsn : SSN -> Cmd Msg
    storeSsn ssn =
      genericSendData (ssnPayload (SSN.toString ssn)) saveSsnEndpoint

| Subheader
    The role of a gatekeeper

Think of a Gatekeeper like the Model in Model-View-Controller frameworks. The Model acts as a gatekeeper that ensures the integrity of all persistence in our app. Similarly, our Exit Gatekeeper ensures the integrity of a Domain concept (SSNs in this case) throughout our app.

| Subheader
    How to control the exits
To add an Exit Gatekeeper, all we need to do is define every function needed to use SSNs internally within the {Code|SSN} module. And of course, each of those functions is responsible for using it appropriately. (And on the other side of that coin, that means that the calling code is free of that responsibility!).

Let's make a function to securely send an SSN. We need to guarantee that:
| List
    - The SSN is encrypted using the proper key
    - It is sent to the correct endpoint
    - It is sent with https
    - It is masked before being being sent to our error reporting

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

You could vigilantly put that in a code review checklist, or come up with all sorts of creative heuristics to avoid that mistake. I like to reach for the Exit Gatekeeper pattern as my first choice. Then you need to check very carefully any time you are modifying the SSN module itself, and you can trust the module and treat it as a blackbox when you're not modifying it.

It's very likely that you'll miss something if you have to think about where SSNs are used throughout your codebase. But it's quite manageable to keep the entire SSN module in your head and feel confident that you're not forgetting anything important.

Here's a simple implementation of our last 4 digits view:

| Monospace
    module SSN exposing (SSN)

    lastFourView : SSN -> Html msg
    lastFourView ssn =
      Html.text ("xxx-xx-" ++ lastFour ssn)



| Signup
    | Config
        buttonText = I want weekly elm tips!
        formId = 863568508
    | Header
        Want weekly tips like this one?
    | List
        - Go beyond learning what great elm code /looks like/. Learn */how to write it/*.
        - Tips you won't find anywhere else to level up your elm skills

| Subheader
    Takeaways
You can start applying the Exit Gatekeeper pattern to your elm code right away!

Here are some steps you can apply:

| List
    #. Notice some data in your codebase that you have to be careful to use safely or correctly
    #. Wrap it in a Custom Type (if you haven't already)
    #. Expose the constructor at first to make the change small and manageable
    #. Get everything compiling and committed!
    #. One by one, copy each function that is consuming your new Custom Type and call it from the new module
    #. Once that's done, you can now hide the constructor, and you now have a proper Exit Gatekeeper for your type!
"""
      }
    ]
