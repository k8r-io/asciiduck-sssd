# == Class: sssd::service
#
#  This is an internal class.
#  The main entry point for the module is the init class
#

class sssd::service {
  if $sssd::manage_service {
    service{$sssd::service_name:
      ensure => $sssd::service_ensure,
      enable => $sssd::service_enable,
    }
  }
  if $sssd::flush_cache_on_change {
    exec{'sss_cache flush':
      command     => 'sss_cache -E',
      path        => $sssd::sss_cache_path,
      refreshonly => true,
    }
  }
}
