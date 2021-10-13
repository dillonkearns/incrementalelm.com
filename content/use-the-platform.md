---
description: Avoid reinventing wheels with progressive enhancement.
cover: 1612016834422-ab208e8c9f31
---

# Use the Platform

Can you send data without using a `<form>` tag with the help of JavaScript? Absolutely.

But with the ubiquity of JavaScript frameworks, we sometimes forget that a lot of built-in functionality comes when we use native features in the Browser Platform.

When we build our own custom versions of functionality without using the features that the Browser Platform provides for us, **we take on responsibility for adding all those enhancements.** Individuals may differ in the degree to which they take responsibility for adding those extra features, but to some degree you'll need to reinvent the wheel. If you wanted to go the extra mile, you could ensure that your form gracefully degrades without JavaScript, but of course the only way to do that would be to use a `<form>` element.

You'll at least want some of the basic user experience that people expect with forms. For example, if you build an interactive form without using a `<form>` tag, users will expect hitting enter to submit the form. This is important for keeping pages accessible, and will also make for better user experiences overall for many different types of users.

"No problem, I'll just add an event listener to listen for the enter key!" Excellent that you're considering keyboard users. Don't forget to test out your implementation, though. Here's a checklist:

- Is it usable with screenreaders?
- Does it show up correctly in the form controls rotor menu on screenreaders? Be sure to test with different screenreaders AND different browsers.
- Do mobile devices show the appropriate submit text in the mobile keyboard?

You'll periodically want to run through this checklist again in case any new built-in form functionality comes out with browser updates, or updates to assitive tools.

Or, you could just use a `<form>` tag. Why reinvent the wheel when the platform has put all this thought in for us already?

Have you ever tried middle clicking on a link to open a page in a new tag and found that it did nothing, or opened a new tab with the landing page instead of the page you middle clicked? The problem is the same here. Reinventing the (mouse) wheel. There are too many things to keep track of when you build that behavior yourself. The culprit is using onclick handlers in JavaScript rather than a good old fashioned `<a>` tag. Let's not reinvent links!

In my opinion, this is always a good strategy: **Use the platform**.
