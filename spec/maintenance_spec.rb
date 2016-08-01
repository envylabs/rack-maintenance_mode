require 'spec_helper'


describe Rack::MaintenanceMode do
  let(:options) { Hash.new }
  subject { app(options).call({}) }


  context 'using the default settings' do
    maintain_env "MAINTENANCE"

    context "with ENV[\"MAINTENANCE\"] enabled" do
      it 'is in maintenance mode' do
        ['t', 'true', 'enable', 'enabled', 'y', 'yes', "yes\n"].each do |setting|
          ENV['MAINTENANCE'] = setting
          expect(app.call({})).to be_a_maintenance_response, "Failed with #{setting.inspect}"
        end
      end

      it 'contains the default response' do
        ['t', 'true', 'enable', 'enabled', 'y', 'yes', "yes\n"].each do |setting|
          ENV['MAINTENANCE'] = setting
          expect(app.call({})).to contain_the_default_response
        end
      end
    end

    context 'with ENV["MAINTENANCE"] disabled' do
      before(:each) { ENV['MAINTENANCE'] = 'false' }

      it { is_expected.to_not be_a_maintenance_response }

      it 'returns the response content' do
        expect(subject.last).to eq ['Ok']
      end
    end

    context 'with ENV["MAINTENANCE"] being nil' do
      before(:each) { ENV['MAINTENANCE'] = nil }

      it { is_expected.to_not be_a_maintenance_response }

      it 'returns the response content' do
        expect(subject.last).to eq ['Ok']
      end
    end
  end


  context 'with a custom mode check (if)' do
    context 'when the custom check returns truthie' do
      let(:options) { {:if => -> env { true }} }
      it { is_expected.to be_a_maintenance_response }
      it { is_expected.to contain_the_default_response }
    end

    context 'when the custom check returns false' do
      let(:options) { {:if => -> env { false }} }

      it { is_expected.to_not be_a_maintenance_response }

      it 'returns the response content' do
        expect(subject.last).to eq ['Ok']
      end
    end
  end


  context 'with a custom template' do
    maintain_env "MAINTENANCE"
    let(:options) { {response: -> env { [503, {'Content-Type' => 'text/plain'}, ['Custom']] } } }

    context 'with maintenance enabled' do
      before(:each) { ENV['MAINTENANCE'] = 'true' }

      it 'returns the custom response' do
        expect(subject.last).to eq ['Custom']
      end
    end

    context 'with maintenance disabled' do
      before(:each) { ENV['MAINTENANCE'] = 'false' }

      it 'returns the original response' do
        expect(subject.last).to eq ['Ok']
      end
    end
  end


  def app(options = {})
    Rack::Builder.new {
      use Rack::MaintenanceMode::Middleware, options
      run -> env { [200, {'Content-Type' => 'text/plain'}, ['Ok']] }
    }
  end
end
