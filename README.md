# ractive-adaptors-parse

Use Parse objects in your [Ractive] components.

*Find more Ractive.js plugins at
[docs.ractivejs.org/latest/plugins](http://docs.ractivejs.org/latest/plugins)*

## Installation

Include `ractive-adaptors-parse.min.js` on your page below Ractive, e.g:

```html
<script src='lib/ractive.min.js'></script>
<script src='lib/ractive-adaptors-parse.min.js'></script>
```

To get ractive-adaptors-backbone you can:

#### Use bower

    $ bower i cprecioso/ractive-adaptors-parse


#### Use npm

    $ npm install --save ractive-adaptors-parse

#### Download

- [Download the latest source](https://github.com/cprecioso/ractive-adaptors-parse/archive/master.zip).

## Usage

If you're using `<script>` tags to manage your dependencies, everything is already set up, and you can use the adaptor like so:

```js
var user = new Parse.User.current();

var ractive = new Ractive({
  el: 'main',
  template: '<h1>Hello {{user.username}}!</h1>',
  data: {
    user: user
  }
});

// If you interact with the model, the view will change
user.set( 'username', 'everybody' );
```

If `Parse` or `Ractive` aren't global variables (e.g. you're using RequireJS), you need to *register* them: 

```js
// Example with CommonJS modules - it also works with AMD
var Parse = require( 'parse' );
var Ractive = require( 'ractive' );
var parseAdaptor = require( 'ractive-adaptors-parse' );

parseAdaptor.Parse = Parse;

var ractive = new Ractive({
  el: 'main',
  template: '<h1>Hello {{user.username}}!</h1>',
  data: {
    user: user
  },

  // this line tells Ractive to look out
  // for Backbone models
  adapt: [ parseAdaptor ]
});
```

## License

ISC

[Ractive]: http://www.ractivejs.org