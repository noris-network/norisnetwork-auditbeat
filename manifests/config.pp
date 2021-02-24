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

  # Use lookup to merge auditbeat::modules config from different levels of hiera
  $modules_lookup = lookup('auditbeat::modules', undef, 'unique', undef)
  # Check to see if anything has been confiugred in hiera
  if $modules_lookup {
    $modules_arr = $modules_lookup
  # check if array is empty, no need to create a config entry then
  } elsif $auditbeat::modules[0].length() > 0 {
    $modules_arr = $auditbeat::modules
  } else {
    $modules_arr = undef
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
      'modules'                 => $modules_arr,
    },
  })

  $auditbeat_config_temp = deep_merge($auditbeat_config, $auditbeat::additional_config)

  if ($auditbeat::xpack != undef) and ($auditbeat::monitoring != undef) {
    fail('Setting both xpack and monitoring is not supported!')
  }

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

  file { '/etc/auditbeat/auditbeat.yml':
    ensure       => $auditbeat::ensure,
    owner        => 'root',
    group        => 'root',
    mode         => $auditbeat::config_file_mode,
    content      => inline_template('<%= @merged_config.to_yaml()  %>'),
    validate_cmd => $validate_cmd,
  }
}
