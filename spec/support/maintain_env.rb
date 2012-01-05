module MaintainEnv
  def maintain_env(*keys)
    before(:each) do
      @_maintain_env = Hash.new
      keys.each do |key|
        @_maintain_env[key] = ENV[key]
      end
    end

    after(:each) do
      @_maintain_env.each_pair do |key, value|
        ENV[key] = value
      end
    end
  end
end

RSpec.configure do |config|
  config.extend MaintainEnv
end
