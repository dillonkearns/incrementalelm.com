---
publishAt: "2021-12-20"
cover: 1590146757945-e4e0151419c8
---

# Frame Then Fill In

How do you get started on a 1,000-piece jigsaw puzzle? I'll bet you get the obvious pieces out of the way quickly: the corners and edges. It turns out that your jigsaw puzzle strategy can teach you a lot about how to write elm code effectively and easily!

## The Jigsaw Approach - Frame Then Fill In

Once you've built out the Frame of a jigsaw puzzle, you've actually accomplished a lot in very little time! You've placed less than 10% of the 1,000 pieces. But in starting with those pieces, you've gained several advantages:

- You placed those pieces very quickly.
- You now have a frame of reference that will make it faster to place the remaining pieces.
- You know the scale of the entire puzzle so you can anchor things like "halfway down" or "at the very top."

## Frame then Fill In your code

What's the equivalent of a puzzle's Frame in elm code?

- Type definitions
- Type annotations

In other words, Types! Types create a Frame for your elm code, giving you a reference point that provides feedback as you work through the details.

## Frame Then Fill In a JSON Decoder

How do you build up a JSON Decoder using the Frame then Fill In technique? Let's walk through the steps.

You're given a JSON endpoint which gives you a list of Attendees for an Event. Attendees always provide their first name, but may not have provided their last name. Here's the Frame for Attendees.

```elm
type alias Attendee =
    { first : String
    , last : Maybe String
    }

decoder : Decoder (List Attendee)
decoder =
    Debug.todo "Implement this"
```

With this tiny step, you've just built a compiling Frame! This gives you exactly the same benefits as with the jigsaw's Frame:

- You could write the Frame (type definition and type annotation) far faster than the details for it.
- You now have a frame of reference that gives you feedback if you take a step in the wrong direction.
- You know the general shape, now you just have to fill in the details.

Avoid intertwining Framing and Filling In. You'll move a lot faster that way.

## Fill In the Frame As Simply As Possible

You have a special advantage in elm that you don't get with the jigsaw puzzle. The puzzle only has a single Frame. But with your elm code, you can break out several sub-problems and use Frame and Fill In to solve each sub-problem. So let's take the smallest step to Fill In our Frame. That way we can create a "Sub-Frame" to move through the rest of the problem even faster!

Your code is compiling and crashing (as is often the case with a Frame). So let's take the smallest step to get it compiling and not crashing. What's the Shortest Path there? It's so obvious you may not even think of it!

```elm
decoder : Decoder (List Attendee)
decoder =
    Decode.succeed []
```

It would have been a longer path if you tried to actually get a Decoder for the Attendee. This small step is like a waypoint, allowing you to get feedback before venturing out on the next small step.

## Frame the Next Sub-Problem

You'll need to decode a single Attendee. So you have a "puzzle" (the next sub-problem). Now you just need a Frame!

```elm
decoder : Decoder (List Attendee)
decoder =
    Decode.list attendeeDecoder

attendeeDecoder : Decoder Attendee
attendeeDecoder =
    Debug.todo "TODO"
```

Again, this Frame is compiling but crashing. So again, the next step is to Fill In the Frame as simply as possible to get it compiling and not crashing.

```elm
attendeeDecoder : Decoder Attendee
attendeeDecoder =
    Decode.succeed { first = "John", last = Nothing }
```

## Completing the Frame

You've just got one more step before you have your complete jigsaw Frame. After that, you'll just have to fill in the details!

```elm
attendeeDecoder : Decoder Attendee
attendeeDecoder =
    Decode.map2 Attendee firstNameDecoder lastNameDecoder

firstNameDecoder : Decoder String
firstNameDecoder =
    Decode.succeed "John"

lastNameDecoder : Decoder (Maybe String)
lastNameDecoder =
    Decode.succeed Nothing
```

## Finally, Just Fill In the Blanks

At this point, you've done the "easy part". The 10% of the puzzle that makes the other 90% way faster and easier. You've built your Frame. Now you just need to get the details right for the first and last name decoders. But you could actually run this decoder and see whether you get back the correct number of Attendees. They would all be named John for now, but hey, you would know that you're on the right track!
