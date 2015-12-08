require 'spec_helper'

describe 'apachelogcompressor' do
  let(:facts) do
    {
      :osfamily => 'Debian',
    }
  end

  it { should contain_class 'ruby' }

  shared_examples 'a proper set of resources' do
    let(:status) { 'present' }
    it { should contain_file('/usr/local/bin/apache-compress-log').with_ensure(status) }
    it { should contain_cron('compress apache logs').with_ensure(status) }
  end

  context 'with no parameters' do
    it_behaves_like 'a proper set of resources'
  end

  context 'with a custom log_root' do
    let(:log_root) { '/rspec/logs' }
    let(:params) { {:log_root => log_root} }
    it_behaves_like 'a proper set of resources'
    it { should contain_file(log_root) }
  end

  context 'in a catalog where our File[$log_root] exists already' do
    let(:pre_condition) do
      [
        "file { '/var/log/apache2': ensure => present, }"
      ]
    end

    it_behaves_like 'a proper set of resources'
  end

  context 'with ensure => absent' do
    let(:status) { 'absent' }
    let(:params) { {:ensure => status} }
    it_behaves_like 'a proper set of resources'
  end
end
