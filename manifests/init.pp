# Installs and configures auditbeat
#
# @summary Installs and configures auditbeat
#
# @example Basic configuration with two modules and output to Elasticsearch
#  class{'auditbeat':
#    modules => [
#      {
#       'module' => 'file_integrity',
#       'enabled' => true,
#       'paths' => ['/bin', '/usr/bin', '/sbin', '/usr/sbin', '/etc'],
#      },
#      {
#       'module' => 'auditd',
#       'enabled' => true,
#       'audit_rules' => '-a always,exit -F arch=b32 -S all -F key=32bit-abi',
#      },
#    ],
#    outputs => {
#     'elasticsearch' => {
#       'hosts' => ['http://localhost:9200'],
#       'index' => 'auditbeat-%{+YYYY.MM.dd}',
#     },
#    },
#  }
#
# @param beat_name the name of the shipper (defaults to the hostname).
# @param fields_under_root whether to add the custom fields to the root of the document.
# @param queue auditbeat's internal queue.
# @param logging the auditbeat's logfile configuration.
# @param outputs the mandatory "outputs" section of the configuration file.
# @param major_version the major version of the package to install.
# @param ensure whether Puppet should manage auditbeat or not.
# @param service_provider which boot framework to use to install and manage the service.
# @param manage_repo whether to add the elastic upstream repo to the package manager.
# @param service_ensure the status of the auditbeat service.
# @param package_ensure the package version to install.
# @param config_file_mode the permissions of the main configuration file.
# @param disable_configtest whether to check if the configuration file is valid before running the service.
# @param tags the tags to add to each document.
# @param fields the fields to add to each document.
# @param xpack the configuration of x-pack monitoring.
# @param modules the required modules to load.
# @param processors the optional processors for events enhancement.
# @param setup the configuration of the setup namespace (kibana, dashboards, template, etc.)
#
class auditbeat (
  String $beat_name                                                   = $::hostname,
  Boolean $fields_under_root                                          = false,
  Hash $queue                                                         = {
    'mem' => {
      'events' => 4096,
      'flush' => {
        'min_events' => 0,
        'timeout' => '0s',
      },
    },
  },
  Hash $logging                                                       = {
    'level' => 'info',
    'selectors'  => undef,
    'to_syslog' => false,
    'to_eventlog' => false,
    'json' => false,
    'to_files' => true,
    'files' => {
      'path' => '/var/log/auditbeat',
      'name' => 'auditbeat',
      'keepfiles' => 7,
      'rotateeverybytes' => 10485760,
      'permissions' => '0600',
    },
    'metrics' => {
      'enabled' => true,
      'period' => '30s',
    },
  },
  Hash $outputs                                                                       = {},
  Enum['5', '6', '7'] $major_version                                                  = '7',
  Enum['present', 'absent'] $ensure                                                   = 'present',
  Optional[Enum['systemd', 'init', 'debian', 'redhat', 'upstart']] $service_provider  = undef,
  Boolean $manage_repo                                                                = true,
  Optional[Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl]] $apt_repo_url                  = undef,
  Optional[Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl]] $yum_repo_url                  = undef,
  Optional[Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl]] $gpg_key_url                   = undef,
  String $gpg_key_id                                                                  = '',
  Enum['enabled', 'running', 'disabled', 'unmanaged'] $service_ensure                 = 'enabled',
  String $package_ensure                                                              = 'present',
  String $config_file_mode                                                            = '0644',
  Boolean $disable_configtest                                                         = false,
  Array[Hash] $modules                                                                = [{}],
  Optional[Array[String]] $tags                                                       = undef,
  Optional[Hash] $fields                                                              = undef,
  Optional[Array[Hash]] $processors                                                   = undef,
  Optional[Hash] $xpack                                                               = undef,
  Optional[Hash] $monitoring                                                          = undef,
  Optional[Hash] $setup                                                               = undef,
  Optional[Hash] $additional_config                                                   = {},
) {

  contain auditbeat::repo
  contain auditbeat::install
  contain auditbeat::config
  contain auditbeat::service

  if $manage_repo {
    Class['auditbeat::repo']
    ->Class['auditbeat::install']
  }

  case $ensure {
    'present': {
      Class['auditbeat::install']
      ->Class['auditbeat::config']
      ~>Class['auditbeat::service']
    }
    default: {
      Class['auditbeat::service']
      ->Class['auditbeat::config']
      ->Class['auditbeat::install']
    }
  }
}
