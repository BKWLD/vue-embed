# Vue Embed
A component that takes a plain text field with script tags and script links and parses

## Props

- `html`: The markup coming from the CMS
- `showLoading`: When true, shows "Loading" on the front end while the external scripts are loading.

## Usage

```javascript
import Embed from '@bkwld/vue-embed'
Vue.component 'embed', Embed
```

```pug
vue-embed(:html='your_html_here')
```

## Why use vue-embed?

`vue-embed` solves the problem of `script` tags not executing on client-rendered pages.  Often these same `script` tags execute normally when the page is loaded via SSG.  A common scenario for this is a CMS with an Embed Block that renders `script` tags to the front end, such as embedded videos or publisher tags.  

## How does vue-embed work?

- On SSG and SSR, `vue-embed` renders the provided HTML code with the `script` tags removed.
- On `mounted`, `vue-embed` finds all `script` tags with external URLs and appends them to the document head with `async="true"`
- On `mounted`, `vue-embed` finds all `script` tags with inline code and executes them using `eval()`.
