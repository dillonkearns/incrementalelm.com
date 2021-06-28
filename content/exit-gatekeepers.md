---
title: "Using elm types to prevent logging social security #'s"
description: One of the most successful techniques I've seen for making sure you don't break elm code the next time you touch it is a technique I call an Exit Gatekeeper.
publishAt: "2020-01-01"
---

Let's say you have these innocent functions in your app. How do you know that you won't get your wires crossed and log a user's social security number?

```elm
securelySaveSSN : String -> Cmd Msg

reportError : String -> Cmd Msg
```

You might wrap it in a type wrapper like so:

```elm
module SSN exposing (SSN(..))

type SSN = SSN String
```

```elm
securelySaveSSN : SSN -> Cmd Msg

reportError : String -> Cmd Msg
```

The `SSN` type wrapper is a good start. But how do you know it won't be unwrapped and passed around somewhere where it could mistakenly be misused?

```elm
storeSSN : SSN -> Cmd Msg
storeSSN (SSN rawSsn) =
    genericSendData (ssnPayload rawSsn) saveSsnEndpoint

genericSendData : Json.Encode.Value -> String -> Cmd Msg
genericSendData payload endpoint =
-- generic data sending function
-- if there's an HTTP error, it sends the payload
-- and error to our error reporting service
-- ⚠️ Not good for SSNs!
```

Whoops, somebody forgot that we had a special `securelySaveSSN` function that encrypts the SSN and masks the SSN when reporting errors. Do you dare look at the commit history? It could well have been your past self (we've all been there)!

Humans make mistakes, so let's not expect them to be perfect. The core issue here is that the `SSN` type wrapper has failed to communicate the limits of how we want it to be used. It's merely a convention to use `securelySaveSSN` instead of calling the generic `genericSendData` with the raw String. In this article, you'll learn a technique that gets the elm compiler to help guide us towards using data as intended: Exit Gatekeepers.

## 🔑 Exit Gatekeepers

So how do we make sure we don't log, Tweet, or otherwise misuse the user's SSN? We control the exits.

There are two ways for the raw data to exit. If raw data exits, then we don't have control over it. So we want to close off these two exit routes.

## 🔓 Unsecure Exit 1 - Public Constructor

If you expose the constructor, then we can pattern match to get the raw SSN. This means that enforcing the rules for how we want to use SSNs leaks out all over our code instead of being in one central place that we can easily maintain.

```elm
-- the (..) exposes the constructor
module SSN exposing (SSN(..))
```

## 🔓 Unsecure Exit 2 - Public Accessor

Similarly, you can unwrap the raw SSN directly from outside the module if we expose an accessor (also known as getters) which returns the /raw data/. In this case, our primitive representation of the SSN is a String, so we could have an unsecure exit by exposing a `toString` accessor.

```elm
module SSN exposing (SSN, toString)

toString : SSN -> String
toString (SSN rawSsn) = rawSsn
```

The public accessor function has the same effect as our publicly exposed constructor did, allowing us to accidentally pass the raw data to our `genericSendData`.

```elm
storeSsn : SSN -> Cmd Msg
storeSsn ssn =
    genericSendData (ssnPayload (SSN.toString ssn)) saveSsnEndpoint
```

## The role of a gatekeeper

Think of a Gatekeeper like the Model in Model-View-Controller frameworks. The Model acts as a gatekeeper that ensures the integrity of all persistence in our app. Similarly, our Exit Gatekeeper ensures the integrity of a Domain concept (SSNs in this case) throughout our app.

## How to control the exits

To add an Exit Gatekeeper, all we need to do is define every function needed to use SSNs internally within the `SSN` module. And of course, each of those functions is responsible for using it appropriately. (And on the other side of that coin, that means that the calling code is free of that responsibility!).

Let's make a function to securely send an SSN. We need to guarantee that:

- The SSN is encrypted using the proper key
- It is sent to the correct endpoint
- It is sent with https
- It is masked before being being sent to our error reporting

We don't want to check for all those things everywhere we call this code every time. We want to be able to make sure the code in this module is good whenever it changes, and then completely trust it from the calling code.

```elm
module SSN exposing (SSN)

securelySendSsn : Ssn -> Http.Request
securelySendSsn ssn =
    Http.post
    { url = "https://yoursecuresite.com/secure-endpoint"
    , body = encryptedSsnBody ssn,
    , expect = ...
    }
```

Now we can be confident that the calling code will never mistakenly send SSNs to the wrong endpoint, or forget to encrypt them!

## Displaying the SSN

What if you only want to display the last 4 digits of the SSN? How do you make sure that you, your team members, and your future self all remember to do that?

You could vigilantly put that in a code review checklist, or come up with all sorts of creative heuristics to avoid that mistake. I like to reach for the Exit Gatekeeper pattern as my first choice. Then you need to check very carefully any time you are modifying the SSN module itself, and you can trust the module and treat it as a blackbox when you're not modifying it.

It's very likely that you'll miss something if you have to think about where SSNs are used throughout your codebase. But it's quite manageable to keep the entire SSN module in your head and feel confident that you're not forgetting anything important.

Here's a simple implementation of our last 4 digits view:

```elm
module SSN exposing (SSN)

lastFourView : SSN -> Html msg
lastFourView ssn =
    Html.text ("xxx-xx-" ++ lastFour ssn)
```

<signup formid="906002494" buttontext="Get weekly elm tips!">
# Get tips to improve your elm code every week

- Go beyond learning what great elm code _looks like_. Learn **how to write it**.
- Tips you won't find anywhere else to level up your elm skills
  </signup>

## Takeaways

You can start applying the Exit Gatekeeper pattern to your elm code right away!

Here are some steps you can apply:

1. Notice some data in your codebase that you have to be careful to use safely or correctly
2. Wrap it in a Custom Type (if you haven't already)
3. Expose the constructor at first to make the change small and manageable
4. Get everything compiling and committed!
5. One by one, copy each function that is consuming your new Custom Type and call it from the new module
6. Once that's done, you can now hide the constructor, and you now have a proper Exit Gatekeeper for your type!
