---
cover: 1599717127111-5c0b51637912
---

# The Hydration Problem

Let's take an honest look at whether Elm is a good fit for building static sites.

The modern wave of JS-based Jamstack tools has created new possibilities with interactivity and productivity, but new challenges for bundle size and performance.

JavaScript is not only expensive to load, but parsing takes time and CPU cycles, especially on slower mobile devices with slow connections. Pre-rendering HTML for pages makes it so JS isn't required for the first paint, but it introduces a new challenge: duplication.

## Data Duplication

It would be a whole lot easier to just pre-render HTML and not ship any JS. But if we want to hydrate the app into a full JavaScript application (or Elm application), then we need the data that was used to pre-render the page. Even though we did the work to pre-render the data, and even though the parts of the page that depended on the data (markdown, for example) may never change - we need to give the JS the data it needs to reconstruct the exact same view. Not to mention ship all the code needed to render that view. Oh, and maybe a markdown parser, syntax highlighting tokenizer, etc. That's a lot of duplicate data and computation!

I made an optimization on this site that uses the elm-pages `DataSource.Port` to perform syntax highlighting at build-time. This is great because it allows me to [[avoid-work-in-the-browser]]. The bundle for this site does not include a syntax highlighting tokenizer for Elm, JS, GraphQL, etc. Nor does any of that work have to happen when you load a page. What happens instead is that the page is pre-rendered with the syntax highlighted code. But then in order to rehydrate the page, I need that data - in this case the parsed tokens - in order to rehydrate the Elm page. That means the highlighted tokens are presented twice: in the pre-rendered HTML, and as JSON data that is used to hydrate the page. Duplicate data!

## View Duplication

That's not the only type of duplication we get from this approach. We also end up paying for our view rendering twice. Once for the pre-rendered HTML output, and then again for including the code to render the view when the page is rehydrated. Oh yes, and then we have to _run_ that code to rehydrate the view - it won't change the resulting view, but we have to execute that code anyway. If you're using a CSS-in-JS, then you'll also be doubling up for pre-rendered CSS and the view code that generated it.

## Hydration with Duplicate Data

Is it conceptually possible to hydrate a page without that duplicate data? Yes and no. The trick is selective hydration, or Islands Architecture. This is exactly what [Astro](https://astro.build/) does, and it's a very exciting new development. I don't personally find the static-HTML-only approach of tools like [11ty](https://www.11ty.dev/) to be an exciting direction, because it puts the burden of selective hydration on the user and so hydration doesn't feel like a first-class citizen. I want to be able to build rich experiences when I need to add in some interactivity.

With Astro, you can choose to hydrate part of the page just by adding a directive where you add the component:

```jsx
<MyComponent client:load />
<MyNonHydratedComponent />
```

I am extremely jealous of this functionality. I think this gives the best of both worlds in many ways. Unlike tools like 11ty, Jekyll, or Hugo, you can use your favorite JS tooling to render pages, and you can hydrate as needed in a first-class way.

At the same time, non-hydrated components are the default. That means that you can render markdown on part of the page, and it will not pull in any of the JS for that component, it will just include that HTML in that part of the page. I find this approach to be very elegant. I love that you can have your cake and eat it to: use JS frameworks, while progressively enhancing HTML and minimizing the cost of JS in the final output.

## Is Elm compatible with islands architecture?

Is it possible? Certainly Astro or a similar framework could allow you to hydrate Elm on part of the page. But I want the full type-safety of building an Elm application. What would this pattern look like in Elm? How could we solve the hydration problem in `elm-pages`?

I've been thinking about this question a lot, and I think I see a path. It's a long path, but I think what lies at the end of that path could be quite rewarding. I always like to keep the big picture on the horizon as I work on projects because these big ideas take time to develop, and I like to know the long-term possibilities as I work on the shorter term features.

The big idea: Selective Hydration for `elm-pages`.

## Selective Hydration

Svelte has taken the approach of "compiling out the framework," and it's proven to be a great way to optimize code for content-driven sites. Well, Elm itself is a compiler, so we can tackle this problem by leveraging Elm's biggest strengths - you can optimize pure functions all you want using the compiler because they are so well-defined. Elm is able to do dead code elimination at the function-level (and completely safely) because of these language characteristics.

If `elm-pages` took the path of becoming a compiler, not just a codegen tool, then it could take advantage of those qualities as well.

Selective Hydration would allow `elm-pages` to tackle the hydration problem. In the compilation step, it could mark parts of a Page Module's view that are _dynamic_ or _static_. A _dynamic_ part of the view would be one that directly uses the `Model`, or that has event handlers. If a page doesn't use the `Model` anywhere, for example, then there is no need to hydrate any of that view code.

But Elm isn't built with a notion of selective hydration. However, it does have the concept of `Html.Lazy`, which is code where the Virtual DOM will not change that part of the view unless the data it depends on changes. So really, this is just an extension of the concept of `Html.Lazy`. The Virtual DOM would need to adopt these _static_ portions of the view from the first page render, and then, similar to `Html.Lazy`, not recompute them after that.

An `elm-pages` compiler could also consider _static_ portions of the page to not count as used code so that it would not be included in the bundled JS code unless it is used elsewhere in dynamic code.

This would be a long road, but conceptually I think it's an exciting path because it could give the benefits of something like Astro's selective hydration, but with a zero-cost abstraction for the user. As a user, you would write `elm-pages` code like normal, but any parts of the code that don't depend on dynamic data would be optimized so they are not hydrated or bundled.

I think that frameworks should try to take inspiration from other tools, and also make use of their unique qualities in order to take an approach that makes the most of the opportunities that come from that ecosystem. Reflecting on this question more, it's become clear that Elm's compiler, and its purity, are the biggest assets, and `elm-pages` can leverage these qualities to do some really unique features and optimizations.

## What do static SPA sites have to offer?

First and foremost, I built `elm-pages` because I wanted to build my content sites with Elm. Why Elm? Well, besides my obvious bias, I also think that Elm is a great choice for transforming, validating, and passing around data. Its types, pure functions, and ecosystem of libraries and tools make it really wonderful to use for those things. You can pull in data with `elm-graphql` from a CMS or API, pass through data to type-safe SEO helper functions, review your code with `elm-review`, [[parse-dont-validate]].

So that's Elm, but what about the broader question of having an SPA static site? Is it a good idea?

One important point is that The Hydration Problem is a problem for first page load. When we do subsequent single-page navigations, we don't have to incur those costs. And we can get snappy page loads, with prefetching and generally pretty optimal data fetching using the SPA approach.

Using a single-page app is a nice mental model for an Elm app, because you can pass around data without lots of glue code. You can also have a `Shared.Model` and use that with a simple mental model.

So with Selective Hydration, `elm-pages` could take on compiler repsonsibilities and we could have our cake and eat it too with optimized static sites built with all our favorite Elm single-page app tools and techniques.

[//begin]: # "Autogenerated link references for markdown compatibility"
[avoid-work-in-the-browser]: avoid-work-in-the-browser "Avoid Work in the Browser"
[parse-dont-validate]: parse-dont-validate "Parse, Don't Validate"
[//end]: # "Autogenerated link references"
