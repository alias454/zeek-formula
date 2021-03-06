# frozen_string_literal: true

# Override by OS
if os.family == 'redhat'
  file_name = '/opt/zeek/etc/node.cfg'
elsif os.family == 'debian'
  file_name = '/opt/zeek/etc/node.cfg'
end

control 'zeek configuration' do
  title 'should match desired lines'

  describe file(file_name) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'zeek' }
    its('mode') { should cmp '0664' }
  end
end
