module Rack
  module MaintenanceMode
    ##
    # This is the primary integration point when using this gem within a Rails
    # application.  This railtie allows for the following customizations:
    #
    # `config.maintenance_mode.if` - used for overriding the logic to determine
    # whether or not the application is in maintenance mode.
    #
    # `config.maintenance_mode.response` - used for generating the maintenance
    # response for the client when in maintenance mode.
    #
    #
    class Railtie < Rails::Railtie
      config.maintenance_mode = ActiveSupport::OrderedOptions.new

      initializer 'rack-maintenance_mode.insert_middleware' do |app|
        app.config.middleware.use 'Rack::MaintenanceMode::Middleware', config.maintenance_mode
      end
    end
  end
end
