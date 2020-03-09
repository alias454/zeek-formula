# Overide by OS
service_name = 'zeek'
if os[:name] == 'centos' and os[:release].start_with?('6')
  service_name = 'zeek'
end

control 'zeek service' do
  impact 0.5
  title 'should be running and enabled'

  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end
end
