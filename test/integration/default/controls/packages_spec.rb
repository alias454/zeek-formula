# frozen_string_literal: true

# Overide by OS
if os.family == 'redhat'
  if os[:release].start_with?('8')
    package_name = 'zeek'
  elsif os[:release].start_with?('7')
    package_name = 'zeek-lts'
  end
elsif os.family == 'debian'
  if os[:release].start_with?('10')
    package_name = 'zeek'
  elsif os[:release].start_with?('9')
    package_name = 'zeek-lts'
  elsif os[:release].start_with?('18')
    package_name = 'zeek'
  end
end

control 'zeek package' do
  title 'should be installed'

  describe package(package_name) do
    it { should be_installed }
  end
end
