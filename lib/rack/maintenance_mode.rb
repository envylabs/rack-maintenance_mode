require "rack/maintenance_mode/version"
require 'rack/maintenance_mode/middleware'

require 'rack/maintenance_mode/railtie' if defined?(Rails)

module Rack
  module MaintenanceMode
  end
end
