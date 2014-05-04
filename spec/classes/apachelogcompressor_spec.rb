require 'spec_helper'

describe 'apache-logcompressor' do
  let(:facts) do
    {
      :osfamily => 'Debian',
    }
  end

  it { should contain_class 'ruby' }

  shared_examples 'a proper set of resources' do
    it { should contain_file('/usr/local/bin/apache-compress-log').with_ensure(status) }
  end

  context 'with no parameters' do
    let(:status) { 'present' }
    it_behaves_like 'a proper set of resources'
  end

  context 'with ensure => absent' do
    let(:status) { 'absent' }
    let(:params) { {:ensure => 'absent'} }
    it_behaves_like 'a proper set of resources'
  end
end
