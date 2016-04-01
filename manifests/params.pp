# == Class: sssd::params
#
#  This is an internal class.
#  The main entry point for the module is the init class
#

class sssd::params {
  case $::osfamily {
    'RedHat': {
      $unsupported = false

      $manage_package = true
      $package_name = ['sssd-common','sssd-client','sssd-ldap']
      $package_ensure = 'present'

      $manage_config = true
      $config_path = '/etc/sssd/sssd.conf'
      $config_owner = 'root'
      $config_group = 'root'
      $config_mode  = '0600'

      $manage_service = true
      $service_name = 'sssd'
      $service_ensure = 'running'
      $service_enable = true

      $sss_cache_path = [ '/usr/sbin/' ]
    }
    'Debian': {
      case $::operatingsystem {
        'Ubuntu': {
          # Check that we're running 14.04 or newer
          if versioncmp($::operatingsystemrelease, '14.04') >= 0 {
            $unsupported = false
          } else {
            $unsupported = true
          }
        }
        'Debian': {
          if versioncmp($::operatingsystemrelease, '8.0') >= 0 {
            $unsupported = false
          } else {
            $unsupported = true
          }
        }
        default: {
          $unsupported = true
        }
      }

      $manage_package = true
      $package_name = ['sssd','sssd-ldap','sssd-tools']
      $package_ensure = 'present'

      $manage_config = true
      $config_path = '/etc/sssd/sssd.conf'
      $config_owner = 'root'
      $config_group = 'root'
      $config_mode  = '0600'

      $manage_service = true
      $service_name = 'sssd'
      $service_ensure = 'running'
      $service_enable = true
      $sss_cache_path = [ '/usr/sbin/' ]
    }
    default: {
      $unsupported = true
    }
  }
  $override_unsupported = false

  $config_source = ''
  $config_content = ''
  $config_template = 'sssd/sssd.conf.erb'
  $services = ['nss','pam']
  $domains = {
    'local' => {
      'id_provider'      => 'local',
    }
  }
  $reconnection_retries = 3
  $re_expression = ''
  $full_name_format = ''
  $try_inotify = ''
  $krb5_rcache_dir = ''
  $default_domain_suffix = ''
  $rotate_uris = false

  $nss_options = {}
  $pam_options = {}
  $sudo_options = {}
  $autofs_options = {}
  $ssh_options = {}


  $flush_cache_on_change = true

}
