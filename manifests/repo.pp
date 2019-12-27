# auditbeat::repo
# @api private
#
# @summary It manages the package repositories to isntall auditbeat
class auditbeat::repo (
  $major_version = $::auditbeat::major_version,
){
  if ($auditbeat::manage_repo == true) and ($auditbeat::ensure == 'present') {
    case $facts['osfamily'] {
      'Debian': {
        include ::apt
        if !defined(Apt::Source['beats']) {
          apt::source{'beats':
            ensure   => $auditbeat::ensure,
            location => "https://artifacts.elastic.co/packages/${major_version}.x/apt",
            release  => 'stable',
            repos    => 'main',
            key      => {
              id     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
              source => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
            },
          }
          if $auditbeat::ensure == 'present' {
            Class['apt::update'] -> Package['auditbeat']
          }
        }
      }
      'RedHat': {
        if !defined(Yumrepo['beats']) {
          yumrepo{'beats':
            ensure   => $auditbeat::ensure,
            descr    => "Elastic repository for ${major_version}.x packages",
            baseurl  => "https://artifacts.elastic.co/packages/${major_version}.x/yum",
            gpgcheck => 1,
            gpgkey   => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
            enabled  => 1,
          }
        }
      }
      'SuSe': {
        exec { 'topbeat_suse_import_gpg':
          command => '/usr/bin/rpmkeys --import https://artifacts.elastic.co/GPG-KEY-elasticsearch',
          unless  => '/usr/bin/test $(rpm -qa gpg-pubkey | grep -i "D88E42B4" | wc -l) -eq 1 ',
          notify  => [ Zypprepo['beats'] ],
        }
        if !defined (Zypprepo['beats']) {
          zypprepo{'beats':
            baseurl     => "https://artifacts.elastic.co/packages/${major_version}.x/yum",
            enabled     => 1,
            autorefresh => 1,
            name        => 'beats',
            gpgcheck    => 1,
            gpgkey      => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
            type        => 'yum',
          }
        }
      }
      default: {
      }
    }
  }
}
