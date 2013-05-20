[![Build Status](https://travis-ci.org/sportngin/conflate.png)](https://travis-ci.org/sportngin/conflate)
[![Code Climate](https://codeclimate.com/github/sportngin/conflate.png)](https://codeclimate.com/github/sportngin/conflate)

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

With Conflate, you can load this information into the `Rails.application.config` object like so:

```ruby
Rails.application.config.foo.thing1
# => "qwerty"
Rails.application.config.foo.thing2
# => "asdf"
```

Use this information in your application or initializers.

Usage
-----

Supply a path to a directory containing YAML files to read, as well as a config
object to put the entries into. For example, do the following for a Rails app:

```ruby
Conflate::Conflator.new(Rails.root.join("config"), Rails.application.config).perform
```

Or, use the [conflate-rails] gem instead, which does this automatically before running initializers.

[conflate-rails]:https://github.com/sportngin/conflate-rails
