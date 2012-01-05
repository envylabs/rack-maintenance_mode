RSpec::Matchers.define :be_a_maintenance_response do |expected|
  match do |actual|
    actual.first == 503
  end
end
