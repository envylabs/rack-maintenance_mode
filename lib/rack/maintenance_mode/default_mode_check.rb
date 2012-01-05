module Rack
  module MaintenanceMode
    ##
    # This is the default behaviour for the gem, with respect to determining
    # whether or not a particular request should be responded to with a
    # maintenance response.
    #
    module DefaultModeCheck
      ##
      # With this implementation, maintenance mode will be enabled if there is
      # an `ENV["MAINTENANCE"]` variable set and it has an acceptable value.
      #
      # Acceptable values for MAINTENANCE: on, yes, y, true, t, enable, enabled
      #
      # If the MAINTENANCE variable is unset or does not match one of the above
      # values, maintenance mode is disabled.
      #
      def self.call(env)
        ENV["MAINTENANCE"].to_s =~ /^(?:on|yes|y|true|t|enabled?)$/i
      end
    end
  end
end
