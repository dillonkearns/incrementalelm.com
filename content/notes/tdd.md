---
description: The red, green, refactor cycle. You start with a failing test that expresses your intention, and make it green the simplest way possible.
---

# Test-Driven Development

This is a key technique for emergent design. TDD makes writing code much more manageable because you don't have to solve every problem at once. You just have to handle a single case.

## Red Green Refactor

### Red

- Focus on a single case - don't build out the whole algorithm. Start with a tiny test case, like "sorting an empty list returns an empty list."
- Start with the simple cases - the goal is to get things working rapidly, not everything at once.
- Wishful thinking - focus on writing the code you wish you had. Don't worry about the implementation. This helps you slice the first step into a more manageable chunk.
- You're calling code you _wish_ you had, so you now have a failing test (could be a failed test assertion or a compiler error). That's why this step is called Red.

### Green

- Do the simplest thing that could possibly work to get your test green.
- Let the test output _drive_ your implementation - Read the failing test's error message (from the failed assertion or compiler error). Your goal is to fix _that specific problem_, not just make the whole thing work.
- **Fake it till you make it** - just focus on getting the current test case passing. Don't write the whole algorithm out. If the test passes by returning an empty list, just hard code that return value. Now the test is Green and you can either Refactor or add another test case (back to Red).

### Refactor

- Only refactor when your tests are Green.
- Do Atomic Refactoring, using tiny steps, ideally with an automated tool like your IDE refactorings.
- **"Make the change easy, then make the easy change"** - Often it's helpful to do a Prepreatory Refactoring. Getting a new test case to pass would be much easier if the code had this structure - refactor the code structure (Refactor), then make the easy change (Red and then Green).

## Resources

- This [Elm Radio episode about testing](https://elm-radio.com/episode/elm-test) goes into Red, Green, Refactor, as well as the specifics of testing in Elm.
- Kent Beck, who created TDD, has a great book on the subject [Test Driven Development: By Example](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530)
- Here is a nice summary of **Test-Driven Development: By Example** <https://stanislaw.github.io/2016/01/25/notes-on-test-driven-development-by-example-by-kent-beck.html>
