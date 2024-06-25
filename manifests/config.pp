# auditbeat::config
# @api private
#
# @summary It configures the auditbeat shipper
class auditbeat::config {
  $auditbeat_bin = '/usr/share/auditbeat/bin/auditbeat'

  $validate_cmd = $auditbeat::disable_configtest ? {
    true => undef,
    default => "${auditbeat_bin} test config -c %",
  }

  $auditbeat_config = delete_undef_values({
    'name'                      => $auditbeat::beat_name ,
    'fields_under_root'         => $auditbeat::fields_under_root,
    'fields'                    => $auditbeat::fields,
    'tags'                      => $auditbeat::tags,
    'queue'                     => $auditbeat::queue,
    'logging'                   => $auditbeat::logging,
    'output'                    => $auditbeat::outputs,
    'processors'                => $auditbeat::processors,
    'setup'                     => $auditbeat::setup,
    'auditbeat'                 => {
      'modules'                 => $auditbeat::modules,
    },
  })

  $auditbeat_config_temp = deep_merge($auditbeat_config, $auditbeat::additional_config)

  if ($auditbeat::xpack != undef) and ($auditbeat::monitoring != undef) {
    fail('Setting both xpack and monitoring is not supported!')
  }

  if Integer($auditbeat::major_version) < 8 {
    # Add the 'xpack' section if supported (version >= 6.2.0)
    if (versioncmp($facts['auditbeat_version'], '7.2.0') >= 0) and ($auditbeat::monitoring) {
      $merged_config = deep_merge($auditbeat_config_temp, {'monitoring' => $auditbeat::monitoring})
    }
    elsif (versioncmp($facts['auditbeat_version'], '6.2.0') >= 0) and ($auditbeat::xpack) {
      $merged_config = deep_merge($auditbeat_config_temp, {'xpack' => $auditbeat::xpack})
    }
    else {
      $merged_config = $auditbeat_config_temp
    }
  } else {
    if $auditbeat::monitoring {
      $merged_config = deep_merge($auditbeat_config_temp, {'monitoring' => $auditbeat::monitoring})
    } else {
      $merged_config = $auditbeat_config_temp
    }
  }

  file { '/etc/auditbeat/auditbeat.yml':
    ensure       => $auditbeat::ensure,
    owner        => 'root',
    group        => 'root',
    mode         => $auditbeat::config_file_mode,
    content      => inline_template('<%= @merged_config.to_yaml()  %>'),
    validate_cmd => $validate_cmd,
  }
}
