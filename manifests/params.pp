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
      $package_name = ['sssd','sssd-ldap']
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
    }
    'Debian': {
      case $::operatingsystem {
        'Ubuntu': {
          case $::lsbdistrelease {
            '14.04': {
              $unsupported = false

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
            }
            default: {
              $unsupported = true
            }
          }
        }
        default: {
          $unsupported = true
        }
      }
    }
    default: {
      $unsupported = true
    }
  }
  $override_unsupported = false

  $config_source = ''
  $config_content = ''
  $config_template = 'sssd/sssd.conf.erb'
  $services = ['nss','passwd']
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

}
