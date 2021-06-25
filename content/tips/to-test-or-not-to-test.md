---
title: To test, or not to test elm code
description: Is it as simple as "only test your business logic?"
publishAt: "2020-01-01"
---

That... is the question Richard Feldman's keynote at Elm in the Spring last week explored. Richard talked about the interplay between unit tests and the elm type system. His general advice is the same as I've described it:

## "In elm, you only test your business logic."

In other words, in the context of a JavaScript app, you have to be really careful to test wiring, and in many ways you have to emulate the role of a type system in your tests.

So a JavaScript/Ruby/other untyped test suite may include checks for:

- Does it give an error if you pass an unwanted type as an argument?
- Does it ever return null when it shouldn't?
- Does it ever enter into an "Impossible State"

## What to test in elm?

So is it as simple as that in elm? You don't need to unit test your wiring, impossible states, or constraints expressed in your types (e.g. non-nullable)?

Yes, I think it is that simple! It's important to understand some context first, though. You can write your code in such a way that it doesn't really seem like business logic. Because the business logic gets buried, so it seems like something else.

It's common for wiring code to get intimately intertwined with core business logic. For example, you can have a view helper function that knows about how to display currency, or how to apply a discount code to a product. So do you test the view code in order to make sure your business logic is correct?

## Flip it around

Instead of testing the business logic that's accessible to test in your code, make the business accessible and test it.

- Keep all your interesting business logic decoupled from wiring and display logic.
- Given your nice, independent business logic modules, write unit tests for those.

<signup buttonText = "Send me weekly elm tips!" formid="906002494">
# Tips for Writing Like a Senior Elm Dev

- Go beyond learning what great elm code _looks like_. Learn _how to write it_.
- Tips you won't find anywhere else to level up your elm skills
  </signup>

## Test-first guides you to decouple business logic

Writing unit tests before versus after writing your implementation is fundamentally different. One of the core benefits of Test-Driven Development is that it guides you to keep your business logic decoupled from your wiring and view logic. Because you're writing tests first, you will naturally write testable code, since you're thinking about how to test it _before_ you think about how to implement it.
