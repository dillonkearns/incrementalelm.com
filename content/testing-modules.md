---
type: tip
description: TODO
publishAt: "2020-09-28"
---

# How do you test code that's not defined in a module?

Have you ever sat down to try to test some code and not known where to start? There's a bug in production, and you want to reproduce it in a unit test before working on the fix. But what do you even test? Where is the problem?

I run into this issue often in Elm codebases. What code is responsible for the bug? The problem is this: the responsibility is diluted, there's not a single point of responsibility. Why? Because if anyone _can_ use the code, if they can depend on it, then they will. And so over time, all the callers of the code become dependent on the internals. The concrete implementation, the data structure. Does it need to have an empty list at the end before you send it off to the server? What's the name of the field? Does it need to be ordered a certain way when you present it? Do you hide certain entires, or display them a certain way? How can you even test it... there's no single _it_... there are dozens of "it"s across your app in all the places it is used.

So if you don't define a single clear module that is responsible for a part of your domain, then everyone becomes responsible.

So how can you even test that? Do you test every single invocation? You can't. The solution is to make it so that there's only one _possible_ place where you can call the code. It's important that you narrow it down, because again, Murphy's Law for calling code... Any internals that _can_ be depended on, _will_ be depended on. So the solution: modules!

How do modules help? Well, modules give us two things. 1) They allow us to organize a set of values/functions/types together. And 2) we can choose to hide some of those as internal details that can't be used outside the module. That's literally all that an Elm module does. And those two mechanics unlock a huge tool for avoiding Murphy's Law of Code Internals.

Let's say we have a fuzzy search dropdown in our app. We have a bug where the fuzzy searching isn't handling non-ASCII characters, like é or ø. Where do you go to fix it?

This is the code we're working with:

```elm
module AdminPage

type Msg
= FuzzyInputText String

fuzzySearchDropdown : Html Msg
fuzzyFilter : String -> Bool
```

We have one type of fuzzy filter function that we use in the `AdminPage`. But what about other pages? They do fuzzy filtering with a lot of the same logic, but it differs just a little bit.

We can find all the call sites and make sure to update those to fix the bug. And we can make sure that the test case we add is a good representation of all the call sites. Something doesn't feel right about that somehow. And for good reason, there's a problem: what about future call sites? This doesn't give us any confidence that our fuzzy search will _stay_ fixed. It's a bug waiting to happen.

It's essential to think about not only what will this code do now, but what will the compiler and structure of the code guide people towards when they add or change behavior in the future?

And if we fix all the call sites, we don't even have the confidence that our tests mean anything! What have we even tested? We could write a test that doesn't give us confidence about all the fuzzy drop downs in our app.

So let's say that we have a bug where our fuzzy search is not handling unicode characters, and just shows no results if you have a non-ascii character.

What's the fix?

We need a FuzzyDropdown module.

module FuzzyDropdown

view : Html Msg
filter : String -> Bool

Notice that the function names become much shorter because in the context of this module the meaning is clear. That's a good sign that you've found a cohesive grouping (and also a good technique for looking for opportunities for splitting modules).
