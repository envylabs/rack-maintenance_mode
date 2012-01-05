module Rack
  module MaintenanceMode
    class Railtie < Rails::Railtie
      config.maintenance_mode = ActiveSupport::OrderedOptions.new

      initializer 'rack-maintenance_mode.insert_middleware' do |app|
        app.config.middleware.use 'Rack::MaintenanceMode::Middleware', config.maintenance_mode
      end
    end
  end
end
