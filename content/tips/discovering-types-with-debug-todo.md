---
type: tip
title: Discovering Types with Debug.todo
description: Debug.todo is a great tool for solving type puzzles. But best as a short-lived tool.
image: "images/article-covers/lofoten-hike.jpg"
---

Debug.todo is a really handy tool if you learn a couple of simple techniques. I'll walk through how to use it effectively, and some pitfalls to avoid.

## What is Debug.todo?

If you're not familiar with Debug.todo, it's a function that can take on any type (much like TypeScript's `any` type).

It's type signature looks like this:

```elm
Debug.todo : String -> a
```

And you use it like this:

```elm

case result of
  Ok value -> value
  Err errorMessage -> Debug.todo ("This should never happen...\n" ++ errorMessage)
```

## Solving type puzzles with Debug.todo

One of my favorite Elm techniques is breaking down a compiler error into smaller steps using Debug.todo.

Let's say we know we start with a value of type X, pass it through some functions to get something of type Y, and then need to call some function to end up with a final value Z.
don't know what kind of function to pass in here:

```elm
parsePhoneNumber :
    Locale
    -> String
    -> Result PhoneNumber.ParseError PhoneNumber.PhoneNumber

parsePhoneNumbers :
    Locale
    -> RemoteData Http.Error (List String)
    -> RemoteData Http.Error (List PhoneNumber)
parsePhoneNumbers locale data =
    data
        |> ??? -- do something with parsePhoneNumber...
```

You can think of `Debug.todo` as a very smart oracle, but who can only answer a very specific type of question: "Is there _any_ value I could use here that would compile?"

So how is that useful here? We can break it into steps.

```elm
parsePhoneNumbers :
    Locale
    -> RemoteData Http.Error (List String)
    -> RemoteData Http.Error (List PhoneNumber)
parsePhoneNumbers locale data =
    data
        |> Debug.todo "Turn this into phone numbers."
```

Since `Debug.todo message` has any type, this first step will always be true. So it's not telling us much, but we can now get more useful feedback.

```elm
parsePhoneNumbers :
    Locale
    -> RemoteData Http.Error (List String)
    -> RemoteData Http.Error (List PhoneNumber)
parsePhoneNumbers locale data =
    data
        |> List.map (Debug.todo "Turn this into phone numbers.")
```

We've just asked our oracle, "is there any function or value that will type-check here?". It will answer, "no, there isn't".

```shell
This function cannot handle the argument sent through the (|>) pipe:

15|     data
16|         |> List.map (Debug.todo "Turn this into phone numbers.")
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The argument is:

    WebData (List String)

But (|>) is piping it to a function that expects:

    List a
```

We've saved ourselves the heartache of building an implementation only to find that the types don't line up. The oracle has told us that we need a function that expects a `WebData`, not a `List`.

The `RemoteData` API gives us this function:

```elm
RemoteData.map : (a -> b) -> RemoteData e a -> RemoteData e b
```

Let's ask the oracle to see if there's a way to make use of this function in our pipeline.

```elm
parsePhoneNumbers :
    Locale
    -> RemoteData Http.Error (List String)
    -> RemoteData Http.Error (List PhoneNumber)
parsePhoneNumbers locale data =
    data
        |> RemoteData.map (Debug.todo "Turn this into phone numbers.")
```

The oracle answers back, "Yes, it is possible to replace this Debug.todo with something to get compiling code!"
