---
description: Automated, frequent production deploys, with built-in (not bolt-on) quality.
---

# Continuous Delivery

It's not just about shipping more frequently, though. It's about reducing the friction. And building in quality (not adding or checking for it after the fact). See Lean (i.e. Toyota Production System).

Ways to reduce friction

## Use an auto formatter tool

Tools like elm-format, or prettier, reduce the friction to making a change. And it's one less thing to think about, or come back to fix before it's "ready for production."

## Use an automated review tool

`elm-review` helps you automate quality checks that reduce the friction of going to production. But it's not just about your core code. Use automated checks as much as possible.

Other examples include:

- Markdown linter for your docs
- Custom linters (for example, are there guidelines for your formatting rules?)
- Design conventions - make sure that you're using the right conventions for your CSS, or consuming the available design system helpers

## Automated Tests

This may be the more obvious technique for reducing friction in your production deploys. But don't forget, it's not just about having tests. If you have unit tests that aren't precisely focused on testing one responsibility, for example, that can increase the friction of change. If you have a large suite of slow, bloated tests, that can reduce your feedback loop and increase the friction to shipping code. So be mindful of _how_ you're testing.

## Feature Flags

Using feature flags frees you up to start shipping low-risk changes to the structure of your code without turning on new features. If you get caught up trying to build features to completion before integrating the new structural foundation into production, it increases the risk and friction of releases because they get too large and become unmangeable.

Integrating the structural foundation for new features into production code before a feature is ready for customers to use requires the formation of several habits. None of them are difficult, but they will seem very uncomfortable at first. Feature flags are an important part of this habit change.

## Safe Refactorings

How often do you perform a guaranteed-correct refactoring using an automated tool? It's more than just a convenience. If you can string together a sequence of several safe refactorings, you can separate **behavior changes** from **structural changes**.

The definition of a refactoring is to change the structure of your code without changing behavior. How often do your refactors change behavior? If they do, they're more of a rewrite than a strict refactor. This subtle difference is a game-changer because it reduces the friction, and allows you to narrow the scope of where you might introduce a problem. As Kent Beck says, "Make the change easy (warning: this may be hard), then make the easy change."

## Micro Commits

Now that you're doing frequent Safe Refactorings, let's get those committed!

You renamed a variable? Excellent! We know the code didn't break because we used our IDE to do the automated refactor. Now let's commit it! That's one less thing to think about when we get to the scary part: changing the code's behavior.

## Automation

If you notice yourself doing the same set of manual steps repeatedly, you can automate those steps to reduce friction and ensure predictible quality.

## Learn Your Shortcuts

Learning keyboard shortcuts to use your IDE and other tools effectively is not just a time-saver. It allows you to move through with 1) less friction, and 2) without losing context. So the time you save is just as important as retaining your flow state.
