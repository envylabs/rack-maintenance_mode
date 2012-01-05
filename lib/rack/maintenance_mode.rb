require "rack/maintenance_mode/version"
require 'rack/maintenance_mode/middleware'

require 'rack/maintenance_mode/railtie' if defined?(Rails)

module Rack
  ##
  # Rack::MaintenanceMode is a Rack middleware which manages sending clients
  # maintenance (HTTP 503) responses, when appropriate.  It is intended to be
  # robust and extensible, allowing you to meet your particular business needs.
  #
  module MaintenanceMode
  end
end
