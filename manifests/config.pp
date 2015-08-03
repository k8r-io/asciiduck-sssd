# == Class: sssd::config
#
#  This is an internal class.
#  The main entry point for the module is the init class
#

class sssd::config inherits sssd {
  if $sssd::manage_config {
    if $sssd::config_source == '' {
      file { $sssd::config_path:
        owner   => $sssd::config_owner,
        group   => $sssd::config_group,
        mode    => $sssd::config_mode,
        content => pick($sssd::config_content,template($sssd::config_template))
      }
    }
    else {
      file { $sssd::config_path:
        owner  => $sssd::config_owner,
        group  => $sssd::config_group,
        mode   => $sssd::config_mode,
        source => $sssd::config_source,
      }
    }
  }
}
