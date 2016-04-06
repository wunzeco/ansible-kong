require 'spec_helper'

kong_conf_dir = '/etc/kong/'
kong_nginx_working_dir = '/usr/local/kong'


describe package('kong') do
  it { should be_installed }
end

%W(
  #{kong_conf_dir}
  #{kong_nginx_working_dir}
).each do |d|
  describe file(d) do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
  end
end

describe file("#{kong_conf_dir}/kong.yml") do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end

describe file("/usr/local/bin/kong") do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe command("/usr/local/bin/kong version") do
  its(:stdout) { should match %r(Kong version: 0.*) }
end

describe process("serf") do
  it { should be_running }
  its(:args) { should match %r(agent -profile=wan -rpc-addr=.*:kong=/usr/local/kong/serf_event.sh) }
end

describe process("nginx") do
  it { should be_running }
  its(:args) { should match %r(-p /usr/local/kong -c nginx.conf) }
end

describe process("dnsmasq") do
  it { should be_running }
end

# verify number of cluster members
describe command('kong cluster members | grep node | wc -l') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match '2' }
end
