module RawContent exposing (content)

import Content exposing (Content)
import Element exposing (Element)


content : Result (Element msg) (Content msg)
content =
    Content.buildAllData { pages = pages, posts = posts }


pages : List ( List String, String )
pages =
    [
    ( ["about"]
      , """|> Article 
    author = Matthew Griffith
    title = How I Learned /elm-markup/
    tags = software other
    description =
        How I learned to use elm-markup.

dummy text of the printing and [typesetting industry]{link| url = http://mechanical-elephant.com }. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In id pellentesque elit, id sollicitudin felis. Morbi eu risus molestie enim suscipit auctor. Morbi pharetra, nisl ut finibus ornare, dolor tortor aliquet est, quis feugiat odio sem ut sem. Nullam eu bibendum ligula. Nunc mollis tortor ac rutrum interdum. Nunc ultrices risus eu pretium interdum. Nullam maximus convallis quam vitae ullamcorper. Praesent sapien nulla, hendrerit quis tincidunt a, placerat et felis. Nullam consectetur magna nec lacinia egestas. Aenean rutrum nunc diam.
Morbi ut porta justo. Integer ac eleifend sem. Fusce sed auctor velit, et condimentum quam. Vivamus id mollis libero, mattis commodo mauris. In hac habitasse platea dictumst. Duis eu lobortis arcu, ac volutpat ante. Duis sapien enim, auctor vitae semper vitae, tincidunt et justo. Cras aliquet turpis nec enim mattis finibus. Nulla diam urna, semper ut elementum at, porttitor ut sapien. Pellentesque et dui neque. In eget lectus odio. Fusce nulla velit, eleifend sit amet malesuada ac, hendrerit id neque. Curabitur blandit elit et urna fringilla, id commodo quam fermentum.
But for real, here's a kitten.


|> Image
    src = http://placekitten.com/g/200/300
    description = What a cute kitten.
Lorem ipsum dolor sit amet, consectetur adipiscing elit. In id pellentesque elit, id sollicitudin felis. Morbi eu risus molestie enim suscipit auctor. Morbi pharetra, nisl ut finibus ornare, dolor tortor aliquet est, quis feugiat odio sem ut sem. Nullam eu bibendum ligula. Nunc mollis tortor ac rutrum interdum. Nunc ultrices risus eu pretium interdum. Nullam maximus convallis quam vitae ullamcorper. Praesent sapien nulla, hendrerit quis tincidunt a, placerat et felis. Nullam consectetur magna nec lacinia egestas. Aenean rutrum nunc diam.
Morbi ut porta justo. Integer ac eleifend sem. Fusce sed auctor velit, et condimentum quam. Vivamus id mollis libero, mattis commodo mauris. In hac habitasse platea dictumst. Duis eu lobortis arcu, ac volutpat ante. Duis sapien enim, auctor vitae semper vitae, tincidunt et justo. Cras aliquet turpis nec enim mattis finibus. Nulla diam urna, semper ut elementum at, porttitor ut sapien. Pellentesque et dui neque. In eget lectus odio. Fusce nulla velit, eleifend sit amet malesuada ac, hendrerit id neque. Curabitur blandit elit et urna fringilla, id commodo quam fermentum.

|> Code
    This is a code block
    With Multiple lines

|> H1
    My section on /lists/

What does a *list* look like?

|> List
    1.  This is definitely the first thing.
        Add all together now
        With some Content
    -- Another thing.
        1. sublist
        -- more sublist
            -- indented
        -- other sublist
            -- subthing
            -- other subthing
    -- and yet, another
        --  and another one
            With some content
"""
      )

  ,( ["articles"]
      , """|> Article
    author = Matthew Griffith
    title = How I Learned /elm-markup/
    tags = software other
    description =
        How I learned to use elm-markup.

Here are some articles. You can learn more at.....

|> IndexContent
    posts = articles
"""
      )

  ,( []
      , """|> Article
    author = Dillon Kearns
    title = Incremental Elm Consulting
    tags = software other
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
    - [How can I write elm code faster, and without getting stuck?]{link|url = /learn/moving-faster-with-tiny-steps}
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

    ]


posts : List ( List String, String )
posts =
    [
    ( ["articles", "exit-gatekeepers"]
      , """|> Article
    author = Dillon Kearns
    tags = asdf
    title = Using elm types to prevent logging social security #'s
    description = TODO


|> Image
    src = /assets/article-cover/exit.jpg
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
    author = Dillon Kearns
    title = Moving Faster with Tiny Steps in Elm
    tags = software other
    description =
        How I learned to use elm-markup.

|> Image
    src = mountains.jpg
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
    author = Dillon Kearns
    title = To test, or not to test elm code?
    tags = software other
    description =
        How I learned to use elm-markup.

|> Image
    src = /assets/article-cover/thinker.jpg
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

    ]
