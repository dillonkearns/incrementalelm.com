---
type: tip
title: Relentless Tiny Habits
description: Manageable codebases don't happen because of brilliant designs. They happen because of relentless tiny habits that move code in the right direction.
publishAt: "2020-09-21"
---

Your development habits and processes are perfectly designed to give you exactly the results you're getting. Do you wish something was different about those results? You'd like it to be easier to understand code, or add new features? The solution is simple and unglamorous. Focus on building the right habits. And look at your development processes to consider how they support or get in the way of building those habits.

So what do those habits look like? In my experience, the key to manageable code is not applying big, complex ideas occasionally (you know those 4 week refactoring branches?). Instead, it comes from applying very simple ideas **persistently**. Relentlessly. No seriously, turn that dial up all the way to 11.

## Things That Get in the Way of Relentless Habits

Habits are key. But in order to build these habits, you need to double down on the pit of success, and remove the pit of failure.

In order to build habits, you need to reduce friction. If your build server is very slow, then you won't build a habit of refactoring as soon as you see the opportunity. If you don't have unit tests, then you won't build the habit of changing your underlying data types to better refelct your domain.

Anything that increases confidence or reduces friction when making changes is a [keystone habit](TODO). That is, getting in the habit of improving your feedback loops and safety nets will make you and your team more effective at building other relentless habits.

## The Core Habits

What are those core habits that keep Elm code manageable? Again, these aren't big, complex ideas applied occasionally. They're _simple_. The hard part isn't the ideas and the techniques, it's building the habits and applying them relentlessly.

Also keep in mind that these are not destinations, but rather directions. These do not represent perfection, but a direction to move towards. Don't let the perfect be the enemy of improvement. Improvement is the name of the game.

The fundamtenal habit is to _build-in and ensure quality at every step_, rather than adding or verifying quality after the fact. That means having feedback loops, like tests and foolproof automation. You can learn more about some of these processes for building-in quality and reducing friction in my [Continuous Delivery glossary](/glossary/continuous-delivery).

### Narrow the source of truth

- Move things into modules
- Use [opaque types](TODO elm radio opaque types episode) to move responsibility to a single pinch point
- Remove ["Impossible States" from your data types](TODO elm radio impossible states)
- Depend on fewer things. Decouple your code. Narrow down the types that you can accept, or can return.

### Name Things Better

[Naming is a process](TODO arlo article). Again, don't let finding the perfect name get in your way. In fact, grouping things together (i.e. extracting a value, function, or module) and giving that group a ridiculous name, is _an improvement_ over not grouping them.

Once you have a cohesive grouping, move towards finding a better name.

## Getting Started

Want to try this out? Here's a simple way to start. Open up your project. Find one of the simple changes above, like a function name that could be more clear. We constantly find these small opportunities for improvements as we read through code.

Use your IDEs automated refactoring to rename the function. And here's the scary part. Commit it. Right now. And push it all the way through to production. If you can't do that, then write down a list of reasons you can't. Now you've got a todo list of things that are getting in the way of building relentless tiny habits to improve code. Once you've been able to successfuly push that tiny improvement through to production, you're off to a great start!

Now do that more. Not bigger, not more complex. Just more frequently. Once that's a habit, congratulations, you're well on your way to relentless tiny steps to improve your codebase!
