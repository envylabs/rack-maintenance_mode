# Rack::MaintenanceMode

Rack::MaintenanceMode is a Rack middleware which manages sending clients
maintenance (HTTP 503) responses, when appropriate.  It is intended to be robust
and extensible, allowing you to meet your particular business needs.

## Maintenance mode is easy. What's the deal?

Glad you asked.  So, yes, in a lot of applications, maintenance mode is simple:
all requests result in a 503 response.  But, as applications grow and business
rules change, and … life happens … well, that's not always sufficient.

Maybe you'd like to 503 on all public requests, but still allow requests from
your IP to pass through it.  Maybe you want to 503 only requests to a particular
subset of your URLs ("/api", for instance).  Maybe you want to be in maintenance
mode based on some complex set of business rules (a particular column in the
database has a set value, and it's a full moon tonight, and Kim Kardashian is
married).  Whatever.

## Installation

If you're using Bundler, then add the gem to your Gemfile:

```ruby
gem 'rack-maintenance_mode'
```

Otherwise:

```bash
$ gem install rack-maintenance_mode
```

## How does it work?

So, it's a Rack middleware.  That's pretty simple.  And, by default, it'll
"just work," by watching for a `ENV["MAINTENANCE"]` variable to be set.  If
it's set, it'll automatically respond with a default 503 response, containing
a simple HTML page and message:

> We are undergoing maintenance right now, please try again soon.

## Customization

The default, while useful, probably isn't exactly what you're looking for, is
it?  So, how do we customize it?

Well, if you're using Rails, then it will integrate with your application
automatically using a Railtie.  This gives us a few things: first, the
middleware will be automatically loaded for you.  And second, this gives you a
simple way to override the default behaviour.

### Customized maintenance mode logic

You can create your own, custom, maintenance mode determination logic in a few
ways.  Well, really… a ton of ways, but at the end of the day, you just need
to encapsulate it in something that responds to `call`.  So, that could be a
simple Proc, a module, a class, and instance, a mock, a stub, … I don't really
care.  That's up to you.

Here's a very simple example of a customization using the Railtie integration
when using this gem with Rails (in `config/application.rb`):

```ruby
require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(:default, Rails.env) if defined?(Bundler)

module MySuperApp
  class Application < Rails::Application
    …
    config.maintenance_mode.if = Proc.new { |env| true }
  end
end
```

Hey look!  Every request is now in maintenance mode!  Ok, probably not so
useful.  So, then:

```ruby
  config.maintenance_mode.if = Proc.new { |env|
    ENV["MAINTENANCE"] == 'enabled' && !(env['PATH_INFO'] =~ /safe/)
  }
```

Now, it'll only 503 if the ENV's maintenance flag is set and the request is to
something other than a "safe" URL (i.e. "http://awesome.com/safe/foo").

Maybe we don't like Procs all over the place.  Can't we make a class?

```ruby
# lib/maintenance.rb
class Maintenance
  def call(env)
    ENV["MAINTENANCE"] == 'enabled' && !(env['PATH_INFO'] =~ /safe/)
  end
end

# config/application.rb
module MySuperApp
  class Application < Rails::Application
    …
    config.maintenance_mode.if = Maintenance.new
  end
end
```

Sure can.

"But wait," I hear you saying.  I still get the crappy default maintenance mode
response.  I'd like to have super-pretty, customized page with CSS-based,
shifting perspectives and whatnot.  Yes, we can.

### Customized responses

Customizing the response is pretty straightforward, as well.  Just as with
customizing the maintenance logic, you can also customize the response.  The
only real requirement, again, is that you use something that responds to `call`,
which can accept a environment hash, and you return a Rack-compatible array.

```ruby
config.maintenance_mode.response = Proc.new { |env| [503, {'Content-Type' => 'text/plain'}, ['Go away']] }
```

This allows you to do some super-useful stuff.  Like, maybe by inspecting the
`env`, you realize that it's an XML request, not HTML.  Well, you could send
and XML response.  Or, maybe you'd like to load that pretty HTML page you've
spent days crafting:

```ruby
config.maintenance_mode.response = Proc.new { |env| [503, {'Content-Type' => 'text/html'}, [Rails.root.join("public/503.html").read]] }
```

Or, maybe you like classes:

```ruby
# lib/maintenance_response.rb
class MaintenanceResponse
  def call(env)
    content_type, body = case Pathname.new(env['PATH_INFO'])
    when '.xml'
      ['application/xml', '<error>Maintenance</error>']
    when '.json'
      ['application/json', 'Maintenance']
    else
      ['text/html', '<html><body>Maintenance</body></html>']
    end

    [503, {'Content-Type' => content_type}, [body]]
  end
end

# config/application.rb
module MySuperApp
  class Application < Rails::Application
    …
    config.maintenance_mode.response = MaintenanceResponse.new
  end
end
```
