Conflate
========

Load YAML files in your config directory into the Rails.application.config.

Example
-------

Let's suppose you have a file 'config/foo.yml', with the following contents:

```yml
thing1: "qwerty"
thing2: "asdf
```

With Conflate, this information gets loaded into the `Rails.application.config` object like so:

```ruby
Rails.application.config.foo.thing1
# => "qwerty"
Rails.application.config.foo.thing2
# => "asdf"
```

Use this information in your application or other initializers.
