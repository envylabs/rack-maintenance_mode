require 'spec_helper'


describe Rack::MaintenanceMode do
  let(:options) { Hash.new }
  subject { app(options).call({}) }


  context 'using the default settings' do
    maintain_env "MAINTENANCE"

    context "with ENV[\"MAINTENANCE\"] enabled" do
      it 'should be in maintenance mode' do
        ['t', 'true', 'enable', 'enabled', 'y', 'yes', "yes\n"].each do |setting|
          ENV['MAINTENANCE'] = setting
          app.call({}).should be_a_maintenance_response, "Failed with #{setting.inspect}"
        end
      end

      it 'should contain the default response' do
        ['t', 'true', 'enable', 'enabled', 'y', 'yes', "yes\n"].each do |setting|
          ENV['MAINTENANCE'] = setting
          app.call({}).should contain_the_default_response
        end
      end
    end

    context 'with ENV["MAINTENANCE"] disabled' do
      before(:each) { ENV['MAINTENANCE'] = 'false' }

      it { should_not be_a_maintenance_response }

      it 'should return the response content' do
        subject.last.should == ['Ok']
      end
    end

    context 'with ENV["MAINTENANCE"] being nil' do
      before(:each) { ENV['MAINTENANCE'] = nil }

      it { should_not be_a_maintenance_response }

      it 'should return the response content' do
        subject.last.should == ['Ok']
      end
    end
  end


  context 'with a custom mode check (if)' do
    context 'when the custom check returns truthie' do
      let(:options) { {:if => -> env { true }} }
      it { should be_a_maintenance_response }
      it { should contain_the_default_response }
    end

    context 'when the custom check returns false' do
      let(:options) { {:if => -> env { false }} }

      it { should_not be_a_maintenance_response }

      it 'should return the response content' do
        subject.last.should == ['Ok']
      end
    end
  end


  context 'with a custom template' do
    maintain_env "MAINTENANCE"
    let(:options) { {response: -> env { [503, {'Content-Type' => 'text/plain'}, ['Custom']] } } }

    context 'with maintenance enabled' do
      before(:each) { ENV['MAINTENANCE'] = 'true' }

      it 'should return the custom response' do
        subject.last.should == ['Custom']
      end
    end

    context 'with maintenance disabled' do
      before(:each) { ENV['MAINTENANCE'] = 'false' }

      it 'should return the original response' do
        subject.last.should == ['Ok']
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
