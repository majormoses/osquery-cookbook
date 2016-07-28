require 'spec_helper'

describe 'osquery_spec::osquery_syslog' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(
      platform: 'ubuntu', version: '14.04', step_into: %w(osquery_syslog)
    )
    runner.node.set['osquery']['syslog']['filename'] = '/etc/rsyslog.d/osquery.conf'
    runner.converge(described_recipe)
  end

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'creates osquery_syslog' do
    expect(chef_run).to create_osquery_syslog('/etc/rsyslog.d/osquery.conf')
  end

  it 'installs rsyslog' do
    expect(chef_run).to install_package('rsyslog')
  end

  it 'creates the osquery syslog conf' do
    expect(chef_run).to create_cookbook_file('/etc/rsyslog.d/osquery.conf')
  end

  it 'restarts rsyslog via notifies' do
    resource = chef_run.cookbook_file('/etc/rsyslog.d/osquery.conf')
    expect(resource).to notify('service[rsyslog]').to(:restart)
    expect(chef_run.service('rsyslog')).to do_nothing
  end
end