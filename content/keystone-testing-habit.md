---
type: tip
description: Test-Driven Development will improve your design and code quality more than any habit.
publishAt: "2020-10-05"
image: "images/article-covers/lofoten-hike.jpg"
---

# The Keystone Testing Habit

We've all experienced routines that set us up for success in our day. For some, starting with a workout makes everything else fall into place. They're more likely to eat healthy, stay on top of emails, and follow other good habits if they start our day with that one keystone habit.

The specific keystone habit will vary from person to person, but the concept is the same. That one habit is worth putting in the extra effort to maintain because it will act as a force multiplier.

With a growing Elm codebase, one keystone habit that keeps all the other habits on track is unit testing. If you follow [[tdd]], you're likely to form better habits around data modeling, code organization, function names, and almost every meaningful measure of code quality.

Let's look at why test-driven development has this effect.

## Extract Modules

What do I even test here? If I asked you to go test an area of your code, what functions would you call? In what module? Are you going to call a function in your `Page/Projects.elm` module from your test? Oh wait, but that function takes in the `Page.Projects.Model`, so I'll need to change the function signature so it just passes in the `Project` and returns a `Project`.

If you sit down to test something, you will naturally feel the pain of using code that's intertwined with your UI code and other unrelated domains. And feeling that pain is _a good thing_.

## Read the Signals the Pain is Sending

Pain is a good thing. _If_ you are able to respond to it. Imagine if you didn't have the ability to feel physical pain. Then imagine that your arm is twisted in a "painful" position. But you're not feeling that pain. By the time you notice, you'd have a broken arm.

The pain is there to send you a message. When you receive that message, you respond, adjust your arm, and avoid harm. No broken arm.

If you're not using test-driven development, you're not feeling the pain of code with lots of dependencies, too many responsibilities in one module, and other code maintainability issues. You're missing the message. Test-driven development lets you tune into that message so you can avoid harm before it's too late. When you sit down to write a test, you will feel these pain points more acutely, which gives you the opportunity to respond.

Feel pain sooner, then you can respond to small pains with ease, not big ones that are hard to mend.

## Freedom to Change and Experiment

Sure, Elm code is known for being very easy to refactor because of the language design itself. But as your codebase grows, you'll run into more complex business logic. Unit tests give you more confidence to try out different ways of modeling your data. So even when it comes to trying to [[Make Impossible States Impossible]] using data modeling techniques, you're going to feel more confident to try many different ways of modeling the data if you're supported by a test suite.

Great design isn't just about thinking hard and coming up with the perfect solution. It's an evolutionary process, and it requires experimentation. The better you are at experimenting, the better your designs will be _over time_ (you can't skip the over time part, because good design is a process not a destination). Test-driven development improves your ability to experiment, so it enables better designs to emerge.

## Emergent Design

Unit tests are essential for allowing you to focus on one case at a time instead of trying to get everything working all at once. This approach of doing the simplest thing that could possibly work allows you to avoid unnecessary abstractions. You can design for your current needs instead of anticipating lots of future needs. Without test-driven development, it's very difficult to slice things down to small steps. With a unit test, you can write a failing test for the simplest possible case (an empty list when sorted is an empty list). Once you get that case working, you can move on to the next case. And at each small step, you have a simple design perfectly suited towards solving that problem (not every possible problem you might encounter in the future). So test-driven development is going to lead you towards a simpler codebase with more lightweight abstractions tailored towards exactly what the code needs.

## Continuous Improvement

There's going to be more friction coming back to code and revisiting a design or making a small change if you don't have tests. And if you're changing the behavior in a small way (fixing a bug or adding a feature), then it will of course be a lot easier to be confident that you've made the desired change without other unintended changes if you have a suite of tests to support you.

## Getting Started

If you want to learn more about the Red-Green-Refactor cycle and applying those techniques in Elm, you can listen to the [Elm Radio episode on testing](https://elm-radio.com/episode/elm-test). Or reach out to me and let me know your questions! Happy testing!


