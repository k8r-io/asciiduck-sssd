# == Class: sssd::install
#
#  This is an internal class.
#  The main entry point for the module is the init class
#

class sssd::install {
  if $sssd::manage_package {
    package {$sssd::package_name:
      ensure => $sssd::package_ensure
    }
  }
}
