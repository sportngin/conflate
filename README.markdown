[![Build Status](https://travis-ci.org/sportngin/conflate.png)](https://travis-ci.org/sportngin/conflate)
[![Code Climate](https://codeclimate.com/github/sportngin/conflate.png)](https://codeclimate.com/github/sportngin/conflate)

Conflate
========

Load YAML files in your config directory into the Rails.application.config.

If you're using Rails, you probably want to use [conflate-rails], which automatically loads YAML files from config/ into Rails.application.config.

Usage
-----

Let's suppose you have a file 'config/statsd.yml', with the following contents:

```yml
# statsd.yml
host: "localhost"
port: 8125
```

With Conflate, load this information (and any other YAML file in your config directory) like so.

```ruby
settings = OpenStruct.new
Conflate::Conflator.new("config", settings).perform
settings.stats
# => {"host" => "localhost", "port" => 8125}
```

The [conflate-rails] gem does the following for you in a Rails app.

```ruby
Conflate::Conflator.new(Rails.root.join("config"), Rails.application.config).perform
Rails.application.config.statsd
# => {"host" => "localhost", "port" => 8125}
```

Around the Web
--------------

* [conflate on GitHub][conflate]
* [conflate on RubyGems][conflate-gem]
* [conflate-rails on GitHub][conflate-rails]
* [conflate-rails on RubyGems][conflate-rails-gem]

[conflate-rails]:https://github.com/sportngin/conflate-rails
[conflate-rails-gem]:https://rubygems.org/gems/conflate-rails
[conflate]:https://github.com/sportngin/conflate
[conflate-gem]:https://rubygems.org/gems/conflate
