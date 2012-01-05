RSpec::Matchers.define :contain_the_default_response do |expected|
  match do |actual|
    actual.last == Rack::MaintenanceMode::Middleware::DEFAULT_RESPONSE.call({}).last
  end
end
