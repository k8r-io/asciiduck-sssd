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
}
