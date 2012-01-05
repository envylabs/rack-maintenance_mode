$:.unshift(File.expand_path('../../lib', __FILE__))
require 'rack/maintenance_mode'
require 'rack'

Dir[File.expand_path("../support", __FILE__) + "/**/*.rb"].each { |f| require f }

