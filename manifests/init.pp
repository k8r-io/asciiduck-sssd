# == Class: sssd
#
# Main entry point for the module
#
# === Parameters
#  Refer to the README.
#

class sssd (
    $manage_package = $sssd::params::manage_package,
    $package_name = $sssd::params::package_name,
    $package_ensure = $sssd::params::package_ensure,
    $manage_config = $sssd::params::manage_config,
    $config_path = $sssd::params::config_path,
    $config_owner = $sssd::params::config_owner,
    $config_group = $sssd::params::config_group,
    $config_mode = $sssd::params::config_mode,
    $config_source = $sssd::params::config_source,
    $config_content = $sssd::params::config_content,
    $config_template = $sssd::params::config_template,
    $manage_service = $sssd::params::manage_service,
    $service_name = $sssd::params::service_name,
    $service_ensure = $sssd::params::service_ensure,
    $service_enable = $sssd::params::service_enable,

    $services = $sssd::params::services,
    $domains = $sssd::params::domains,
    $reconnection_retries = $sssd::params::reconnection_retries,
    $re_expression = $sssd::params::re_expression,
    $full_name_format = $sssd::params::full_name_format,
    $try_inotify = $sssd::params::try_inotify,
    $krb5_rcache_dir = $sssd::params::krb5_rcache_dir,
    $default_domain_suffix = $sssd::params::default_domain_suffix,
    $rotate_uris = $sssd::params::rotate_uris,

    $nss_options = $sssd::params::nss_options,
    $pam_options = $sssd::params::pam_options,
    $sudo_options = $sssd::params::sudo_options,
    $autofs_options = $sssd::params::autofs_options,
    $ssh_options = $sssd::params::ssh_options,

    $sss_cache_path = $sssd::params::sss_cache_path,
    $flush_cache_on_change = $sssd::params::flush_cache_on_change,

    $unsupported = $sssd::params::unsupported,
    $override_unsupported = $sssd::params::override_unsupported,
  ) inherits sssd::params {

  if $sssd::unsupported and ! $sssd::override_unsupported {
    fail("Unsupported OS ${::operatingsystem} ${::operatingsystemrelease}")
  }

  validate_bool($manage_package)
  if !is_array($package_name) {
    validate_string($package_name)
  }
  validate_re($package_ensure,['^(present|absent|latest)$','^(\d+\.)*\d+$'])
  validate_bool($manage_config)
  validate_absolute_path($config_path)
  validate_string($config_owner)
  validate_string($config_group)
  validate_re($config_mode,['^[0-7]{3,4}$'])
  validate_string($config_source)
  validate_string($config_content)
  validate_string($config_template)
  validate_bool($manage_service)
  validate_string($service_name)
  validate_re($service_ensure,['^(running|stopped)$'])
  validate_bool($service_enable)

  validate_bool($rotate_uris)

  validate_array($services)
  validate_hash($domains)
  validate_hash($nss_options)
  validate_hash($pam_options)
  validate_hash($sudo_options)
  validate_hash($autofs_options)
  validate_hash($ssh_options)

  validate_array($sss_cache_path)
  validate_bool($flush_cache_on_change)

  validate_bool($unsupported)
  validate_bool($override_unsupported)

  class { 'sssd::install': } ->
  class { 'sssd::config': } ~>
  class { 'sssd::service': } ->
  Class['sssd']
}
