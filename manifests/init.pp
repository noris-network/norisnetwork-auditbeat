# Class: auditbeat
# ================
#
# * `beat_name`: 
# [String] the name of the shipper (default: the *hostname*).
#
# * `fields_under_root`: 
# [Boolean] whether to add the custom fields to the root of the document (default is *false*).
#
# * `queue`: 
# [Hash] auditbeat's internal queue, before the events publication (default is *4096* events in *memory* with immediate flush).
#
# * `logging`: 
# [Hash] the auditbeat's logfile configuration (default: writes to `/var/log/auditbeat/auditbeat`, 
# maximum 7 files, rotated when bigger than 10 MB).
#
# * `outputs`: 
# [Hash] the options of the mandatory [outputs] (https://www.elastic.co/guide/en/beats/auditbeat/current/configuring-output.html) section of the configuration file (default: undef).
#
# * `major_version`: 
# [Enum] the major version of the package to install (default: '6', the only accepted value. Implemented for future reference).
#
# * `ensure`: 
# [Enum 'present', 'absent']: whether Puppet should manage `auditbeat` or not (default: 'present').
#
# * `service_provider`: 
# [Enum 'systemd', 'init'] which boot framework to use to install and manage the service (default: 'systemd').
#
# * `service_ensure`: 
# [Enum 'enabled', 'running', 'disabled', 'unmanaged'] the status of the audit service (default 'enabled'). In more details:
#     * *enabled*: service is running and started at every boot;
#     * *running*: service is running but not started at boot time;
#     * *disabled*: service is not running and not started at boot time;
#     * *unamanged*: Puppet does not manage the service.
#
# * `package_ensure`: 
# [String] the package version to install. It could be 'latest' (for the newest release) or a specific version 
# number, in the format *x.y.z*, i.e., *6.2.0* (default: latest).
#
# * `config_file_mode`: 
# [String] the octal file mode of the configuration file `/etc/auditbeat/auditbeat.yaml` (default: 0644).
#
# * `disable_configtest`: 
# [Boolean] whether to check if the configuration file is valid before attempting to run the service (default: true).
#
# * `tags`: 
# [Array[Strings]]: the tags to add to each document (default: undef).
#
# * `fields`: 
# [Hash] the fields to add to each document (default: undef).
#
# * `modules`: 
# [Array[Hash]] the required [modules] (https://www.elastic.co/guide/en/beats/auditbeat/current/auditbeat-modules.html) to load (default: undef).
#
# * `processors`: 
# [Array[Hash]] the optional [processors] (https://www.elastic.co/guide/en/beats/auditbeat/current/defining-processors.html) for event enhancement (default: undef).
#
# Examplses
# ================
#
# @example
#
# class{'auditbeat':
#     modules => [
#       {
#         'module' => 'file_integrity',
#         'enabled' => true,
#         'paths' => ['/bin', '/usr/bin', '/sbin', '/usr/sbin', '/etc'],
#       },
#       {
#         'module' => 'auditd',
#         'enabled' => true,
#         'audit_rules' => '-a always,exit -F arch=b32 -S all -F key=32bit-abi',
#       },
#     ],
#     outputs => {
#       'elasticsearch' => {
#         'hosts' => ['http://localhost:9200'],
#         'index' => 'auditbeat-%{+YYYY.MM.dd}',
#       },
#     },


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
  Hash $outputs                                                       = {},
  Enum['6'] $major_version                                            = '6',
  Enum['present', 'absent'] $ensure                                   = 'present',
  Enum['systemd', 'init'] $service_provider                           = 'systemd',
  Boolean $manage_repo                                                = true,
  Enum['enabled', 'running', 'disabled', 'unmanaged'] $service_ensure = 'enabled',
  String $package_ensure                                              = 'latest',
  String $config_file_mode                                            = '0644',
  Boolean $disable_configtest                                         = false,
  Optional[Array[String]] $tags                                       = undef,
  Optional[Hash] $fields                                              = undef,
  Optional[Array[Hash]] $modules                                      = undef,
  Optional[Array[Hash]] $processors                                   = undef,
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
