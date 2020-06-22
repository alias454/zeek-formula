# frozen_string_literal: true

# Overide by OS
service_name = 'zeek'
service_name = 'zeek' if (os[:name] == 'centos') && os[:release].start_with?('7')

control 'zeek service' do
  impact 0.5
  title 'should be running and enabled'

  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end
end
