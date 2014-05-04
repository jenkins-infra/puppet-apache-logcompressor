# == Class: apache-logcompressor
#
#
# === Examples
#
#  class { apache-logcompressor:
#  }
#
# === Authors
#
# R. Tyler Croy <tyler@linux.com>Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 R. Tyler Croy
#
class apache-logcompressor(
  $ensure = 'present',
) {
  include ruby

  file { '/usr/local/bin/apache-compress-log':
    ensure => $ensure,
    source => "puppet://modules/${module_name}/compress-log.rb",
    mode   => '0700',
  }

  #cron { 'compress apache logs':
  #}
}
