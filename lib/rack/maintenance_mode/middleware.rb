require 'rack/maintenance_mode/default_mode_check'

module Rack
  module MaintenanceMode
    ##
    # A Rack middleware to automatically put the Rack application into
    # maintenance mode (HTTP 503).
    #
    # The default behaviour may be overridden by passing specific options at
    # the time of initialization.
    #
    # Available options:
    #
    # `:if` - Any object which responds to `call(hash)` and returns a
    # true/false-like result.  Used for determining whether or not we're in
    # maintenance mode.
    #
    # `:response` - Any object which responds to `call(hash)` and returns a
    # Rack-compatible response array.  Used for generating the client response
    # when in maintenance mode.
    #
    class Middleware
      DEFAULT_RESPONSE = Proc.new { |env| [503, {"Content-Type" => "text/html"}, ["<html><body><h2>We are undergoing maintenance right now, please try again soon.</body></html>"]] }

      def initialize(app, options = {})
        @app = app
        @mode_check = options[:if] || DefaultModeCheck
        @response = options[:response] || DEFAULT_RESPONSE
      end

      def call(env)
        maintenance_mode?(env) ? maintenance_response(env) : standard_response(env)
      end


      private


      def maintenance_mode?(env)
        @mode_check.call(env)
      end

      def maintenance_response(env)
        @response.call(env)
      end

      def standard_response(env)
        @app.call(env)
      end
    end
  end
end
