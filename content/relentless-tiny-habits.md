---
type: tip
description: Manageable codebases don't happen because of brilliant designs. They happen because of relentless tiny habits that move code in the right direction.
publishAt: "2020-09-28"
image: "images/article-covers/lofoten-hike.jpg"
---

# Relentless Tiny Habits

Your development habits and processes are perfectly designed to give you exactly the results you're getting. Do you wish something was different about those results? You'd like it to be easier to understand code, or add new features? The solution is simple and unglamorous. Focus on building the right habits. And step back to look at your development processes to consider how they support or hinder building those habits.

So what do those habits look like? The key to manageable code is not applying big, complex ideas occasionally (you know, those 4 week refactoring branches). Instead, it comes from applying very simple ideas **persistently**. Relentlessly. No seriously, turn that dial up all the way to 11.

## Things That Get in the Way of Relentless Habits

Habits are key. But in order to build these habits, you need to double down on rewarding those habits by removing friction. Habits form when you get that positive signal when you perform the habit.

If your build server is very slow, then you won't build a habit of refactoring as soon as you see the opportunity. If you don't have unit tests, then you won't build the habit of changing your underlying data types to better reflect your domain. If setting up a unit test is cumbersome then you won't write tests.

Anything that increases confidence or otherwise reduces friction to making changes is a [[keystone habit]]. That is, getting in the habit of improving your feedback loops and safety nets will enable you and your team to build other good habits faster. Keystone habits are a key ingredient to Relentless, Tiny Habits.

## The Core Habits

What are those core habits that keep Elm code manageable? Again, these aren't big, complex ideas applied occasionally. They're _simple_. The hard part isn't the ideas and the techniques, it's building the habits and applying them relentlessly.

Also keep in mind that these are not destinations, but rather directions. These do not represent perfection, but a direction to move towards. Don't let the perfect be the enemy of improvement. Improvement is the goal at every step.

### Narrow the source of truth

- Move things into modules
- Use [opaque types](https://elm-radio.com/episode/intro-to-opaque-types) to move responsibility to a single pinch point
- Remove ["Impossible States" from your data types](https://elm-radio.com/episode/impossible-states/)
- Depend on fewer things. Decouple your code. Narrow down the types that you can accept, or can return.
- Turn redundant state that can get out of sync into derived state that can't be out of sync

These may sound like very fundamental techniques, and they are! But that's the point. It's not any individual step that's profound, it's the result of applying these steps constantly. The more you narrow the source of truth, the easier it will be to read and change code. Move in that direction 100 times, and now you have a transformation that was composed of several mundane changes.

### Name Things Better

[Naming is a process](https://www.digdeeproots.com/articles/on/naming-as-a-process/). Again, don't let finding the perfect name get in your way. In fact, grouping things together (i.e. extracting a value, function, or module) and giving that group a ridiculous name, is _an improvement_ over not grouping them.

Once you have a cohesive grouping, move towards finding a better name.

### Tiny Steps That Maintain a Working State

As you move in the right direction, you want to _build-in and ensure quality at every step_, rather than adding or verifying quality after the fact. That means having feedback loops, like tests and foolproof automation. You can learn more about some of these processes for building-in quality and reducing friction in [[Continuous Delivery]].
Make smaller steps, and keep things in a working state at each point along the way.

- Refactor with several small steps that keep your tests (and compiler) green
- Use automated refactorings in your IDE
- Use an [`elm-review`](https://github.com/jfmengels/elm-review) rule to catch code quality with a shorter feedback loop

## Getting Started

Want to try applying some Relentless, Tiny Habits? Here's a simple way to start. Open up your project. Find one of the simple changes above, like a function name that could be more clear. We constantly find these small opportunities for improvements as we read through code.

Now use your IDE's automated refactoring to rename the function. And here's the scary part. Commit it. Right now. And push it all the way through to production. If you can't do that, then **write down a list of reasons you can't**. Now you've got a todo list of things that are getting in the way of building relentless tiny habits to improve code. Once you've gotten through your todo list and are able to push that tiny improvement through to production, you're off to a great start!

Now do that more. Not bigger, not more complex. Just more frequently. Once that's a habit, congratulations, you're now using a Tiny Habit to improve your codebase! Now, just keep doing it. Relentlessly.
