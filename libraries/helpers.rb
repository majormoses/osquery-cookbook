# Helper modules for common case statements.
module Osquery
  def compat_audit
    required = Chef::Version.new('12.1.0')
    current = Chef::Version.new(node['chef_packages']['chef']['version'])
    current >= required
  end

  def osquery_s3
    'https://osquery-packages.s3.amazonaws.com'
  end

  def osquery_config_path
    case node['platform']
    when 'mac_os_x'
      '/var/osquery/osquery.conf'
    when 'centos', 'ubuntu', 'redhat'
      '/etc/osquery/osquery.conf'
    end
  end

  def osquery_packs_path
    case node['platform']
    when 'mac_os_x'
      '/var/osquery/packs'
    when 'centos', 'ubuntu', 'redhat'
      '/usr/share/osquery/packs'
    end
  end

  def osquery_file_group
    case node['platform']
    when 'mac_os_x'
      'wheel'
    when 'centos', 'ubuntu', 'redhat'
      'root'
    end
  end
end

Chef::Recipe.send(:include, Osquery)
Chef::Resource.send(:include, Osquery)
Chef::Provider.send(:include, Osquery)