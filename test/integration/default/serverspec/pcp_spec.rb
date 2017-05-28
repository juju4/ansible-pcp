require 'serverspec'

# Required by serverspec
set :backend, :exec

## Use Junit formatter output, supported by jenkins
#require 'yarjuf'
#RSpec.configure do |c|
#    c.formatter = 'JUnit'
#end

describe package('pcp') do
  it { should be_installed }
end

describe service('pcp'), :if => os[:family] == 'ubuntu' || os[:family] == 'debian' do
  it { should be_enabled   }
  it { should be_running   }
end
describe service('pmcd'), :if => os[:family] == 'redhat' do
  it { should be_enabled   }
  it { should be_running   }
end
describe service('pmie'), :if => os[:family] == 'redhat' do
  it { should be_enabled   }
  it { should be_running   }
end
describe service('pmlogger'), :if => os[:family] == 'redhat' do
  it { should be_enabled   }
  it { should be_running   }
end
describe service('pmproxy'), :if => os[:family] == 'redhat' do
  it { should be_enabled   }
  it { should be_running   }
end

describe process("pmcd") do
  its(:user) { should eq "pcp" }
end
describe process("pmie") do
  its(:user) { should eq "pcp" }
  its(:args) { should match /-b -h local/ }
end
describe process("pmlogger") do
  its(:user) { should eq "pcp" }
  its(:args) { should match /-c config.default -m pmlogger_check/ }
end

describe port(4330) do
  it { should be_listening }
end
describe port(44321) do
  it { should be_listening }
end
## if web api
#describe port(44323) do
#  it { should be_listening }
#end

describe command('pcp -h localhost') do
  its(:stdout) { should match /Performance Co-Pilot configuration on/ }
  its(:stdout) { should match /services: pmcd/ }
  its(:exit_status) { should eq 0 }
end
describe command('pcp verify --secure -v') do
  its(:stdout) { should match /completed secure install verification/ }
  its(:exit_status) { should eq 0 }
end

