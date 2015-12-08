# == Class: apachelogcompressor
#
# === Examples
#
#  class { apachelogcompressor:
#  }
#
# === Authors
#
# R. Tyler Croy <tyler@linux.com>
#
# === Copyright
#
# Copyright 2015 R. Tyler Croy
#
class apachelogcompressor(
  $ensure   = 'present',
  $log_root = '/var/log/apache2',
) {
  # <http://docs.puppetlabs.com/puppet/latest/reference/lang_containment.html>
  contain 'ruby'

  # If we don't have a resource in the catalog already for our log_root, we
  # should make sure to declare it
  if !defined(File[$log_root]) {
    file { $log_root:
      ensure => directory,
    }
  }

  file { '/usr/local/bin/apache-compress-log':
    ensure => $ensure,
    source => "puppet:///modules/${module_name}/compress-log.rb",
    mode   => '0700',
  }

  cron { 'compress apache logs':
    ensure  => $ensure,
    command => "cd ${log_root} && /usr/local/bin/apache-compress-log",
    user    => 'root',
    minute  => 15,
    require => [File['/usr/local/bin/apache-compress-log'],
                Class['ruby'],
                File[$log_root]],
  }
}
