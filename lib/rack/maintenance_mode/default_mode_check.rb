module Rack
  module MaintenanceMode
    module DefaultModeCheck
      def self.call(env)
        ENV["MAINTENANCE"].to_s =~ /^(?:on|yes|y|true|t|enabled?)$/i
      end
    end
  end
end
