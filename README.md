# ractive-adaptors-parse

Use Parse objects in your [Ractive] components. Supports two-way binding.

*Find more Ractive.js plugins at
[docs.ractivejs.org/latest/plugins](http://docs.ractivejs.org/latest/plugins)*

## Installation

Include `ractive-adaptors-parse.min.js` on your page below Ractive. It's also recommended you use [ractive-adaptors-promise], but it is optional.

```html
<script src='lib/ractive.min.js'></script>
<script src='lib/ractive-adaptors-promise.min.js'></script> <!-- Optional -->
<script src='lib/ractive-adaptors-parse.min.js'></script>
```

To get ractive-adaptors-parse you can:

#### Use bower

    $ bower i cprecioso/ractive-adaptors-parse


#### Use npm

    $ npm install --save cprecioso/ractive-adaptors-parse
    # ractive-adaptors-parse is in alpha and is not yet in the npm registry

#### Download

- [Download the latest source](https://github.com/cprecioso/ractive-adaptors-parse/archive/master.zip).

## Usage

If you're using `<script>` tags to manage your dependencies, everything is already set up, and you can use the adaptor like so:

```js
var user = new Parse.User.current();
var anotherUser = new Parse.User.createWithoutData("xxxxxxx");

var ractive = new Ractive({
  el: 'main',
  template: '<h1>Hello {{user.username}}, you have a friend request from {{anotherUser.username}}!</h1>',
  adapt: [ "Parse", "Promise" ] // The promise adaptor is optional but highly recommended.
  data: {
    user: user,
    anotherUser: anotherUser.fetch() // Only if you've also included the Promise adaptor. Otherwise, you're on your own with promises.
  }
});

// If you interact with the model, the view will change. Saving is still your responsibility.
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
  // for Parse models
  adapt: [ parseAdaptor ]
});
```

## Credits
Thank you to [ractive-adaptors-backbone], as their code guided mine. 

## License

ISC

[Ractive]: http://www.ractivejs.org
[#1]: https://github.com/cprecioso/ractive-adaptors-parse/issues/1
[#4]: https://github.com/cprecioso/ractive-adaptors-parse/issues/4
[ractive-adaptors-backbone]: https://github.com/ractivejs/ractive-adaptors-backbone
[ractive-adaptors-promise]: https://github.com/lluchs/Ractive-adaptors-Promise
