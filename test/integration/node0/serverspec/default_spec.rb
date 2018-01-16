require 'spec_helper'

kong_conf_dir = '/etc/kong/'
kong_nginx_working_dir = '/usr/local/kong'


describe package('kong-community-edition') do
  it { should be_installed }
end

describe file(kong_conf_dir) do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file(kong_nginx_working_dir) do
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file("#{kong_conf_dir}/kong.conf") do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end

describe file("/etc/logrotate.d/kong") do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
end

describe file("/usr/local/bin/kong") do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by 'root' }
end

describe file("/etc/init.d/kong") do
  it { should be_file }
  it { should be_owned_by 'root' }
end

describe file("/etc/rc2.d/S20kong") do
  it { should be_symlink }
  it { should be_linked_to '../init.d/kong' }
end

describe command("/usr/local/bin/kong version") do
  its(:stdout) { should match %r[(Kong version:\s)?0.*]i }
end

describe process("nginx") do
  it { should be_running }
  its(:args) { should match %r(-p /usr/local/kong -c nginx.conf) }
end
