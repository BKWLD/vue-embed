# Vue Embed
A component that takes a plain text field with script tags and script links and parses

## Props
`html`: The markup coming from the CMS

## Usage

```javascript
import Embed from '@bkwld/vue-embed'
Vue.component 'embed', Embed
```

```pug
vue-embed(:html='your_html_here')
```