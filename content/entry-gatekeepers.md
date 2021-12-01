# Entry Gatekeepers

How does the bartender at your local bar know it's okay to serve you? In many cases, it's because the bouncer already checked your ID before you entered. This allows the busy bartender to focus on their job and just serve their fine customers drinks! In this post, you'll learn how to make your elm code just as organized as the bouncer and the bartender.

## Type Bouncers: The elm equivalent of checking your ID

How do you know an Int is an Int in Elm, and not a String or some other type? Because Elm only allows data to become an Int after it goes through a Type Bouncer.

toInt : String -> Maybe Int

If we pass an invalid Int, the Type Bouncer doesn't let our value in!

toInt "not an Int actually" -- => Nothing

And because the Bouncer only lets in proper Ints, once we have an Int we don't have to "check its ID" every time we use it. We can just do Int things with it, like summing or multiplying it with other Ints. We can focus on our Int operations, rather than on making sure it actually is an Int.

## Bouncers for elm Custom Types

Believe it or not, you can get a similar level of confidence that your Custom Type meets your entrance criteria! Here's an example of a Type Bouncer for a Custom Type from the elm core packages:

Regex.fromString : String -> Maybe Regex

If we get back a Regex, we know it's a valid one. So we can safely assume that anything of type Regex is Valid.

Let's apply the same pattern with a simple example: a type for degrees Kelvin. But first, let me introduce the 3 steps for creating a bouncer from scratch.

## The 3 steps to introduce a Type Bouncer

1. You want to create a type that represents either
   1. A Validation (Regex.fromString validates that it is a regex for example)
   2. Parsed Data (parseDate "2019-09-04")
   3. An identity (for example an API request shouldn't accept ANY String, it specifically needs to know it's an authToken)
   4. Or just Semantic Meaning (10 meters, 72 degrees Fahrenheit)
2. Introduce a Custom Type (if you don't already have one)
3. Create your Bouncer: a restrictive way to create your Custom Type that guarantees it is what you say it is

## A simple example

Let's try out the steps with our degrees Kelvin example!

Step 1) In this case, we want to represent a validation (we can only turn Ints greater than 0 into our Custom Type)
Steps 2 and 3) Let's create our Custom Type and Type Bouncer.

```elm
module Kelvin exposing (Kelvin)

type Kelvin = Kelvin Int

fromKelvin : Float -> Maybe Kelvin
fromKelvin degreesKelvin =
  if degreesKelvin >= 0 then
    Just (Kelvin degreesKelvin)
  else
    Nothing
```

Since our Type Bouncer has to validate the input (>= 0), it can't just return our Custom Type directly. It can only give back a Kelvin if it is VALID. In this case, we pass back Nothing if it is not valid.

## An Identity Type Bouncer

That's simple enough when we can confirm that a unit is valid by checking if it's non-negative. But what about something more subtle like an AuthToken? How do we know it's actually an AuthToken and not just any other String?

Let's look back at Step 3:

> Create your Type Bouncer: a restrictive way to create your type that guarantees it is what you say it is .

When we're dealing with Parsed Data or Validations, we can look at the value and tell you whether it checks out. But we can't just look at any old String and tell you whether it's an AuthToken! We need to actually confirm that it /came from the right API request/.

So our Type Bouncer needs to be a little more involved... it needs to actually go and get the value for us to make sure it is indeed an AuthToken!

```elm
module AuthToken exposing (AuthToken, get)

import Http
import Json.Decode

type AuthToken = AuthToken String

get :
  { clientId : String, clientSecret : String }
  -> (Result Http.Error AuthToken -> msg)
  -> Cmd msg
get { clientId, clientSecret } toMsg =
  Http.get
    { url =
        "https://api.example.com/authenticate?clientId="
          ++ clientId
          ++ "&clientSecret="
          ++ clientSecret
    , expect =
      Http.expectJson toMsg
        (Json.Decode.map AuthToken Json.Decode.string)
    }
```

Since the AuthToken constructor isn't exposed, the only way to create one is by making an API request. So we can guarantee that if we got one back, it is indeed an AuthToken!
