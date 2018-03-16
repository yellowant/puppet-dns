# == Class: dns::server::default
#
class dns::server::default (

  Stdlib::Absolutepath $default_file          = $dns::server::params::default_file,
  String $default_template      = $dns::server::params::default_template,

  Variant[Enum['yes', 'no'], Undef] $resolvconf            = undef,
  $options               = undef,
  Variant[Stdlib::Absolutepath, Undef] $rootdir               = undef,
  Variant[Enum['yes', 'no', ''], Undef] $enable_zone_write     = undef,
  Variant[Enum['yes', 'no', '1', '0', ''], Undef] $enable_sdb            = undef,
  $disable_named_dbus    = undef,
  Variant[Stdlib::Absolutepath, Undef] $keytab_file           = undef,
  Variant[Enum['yes', 'no', ''], Undef] $disable_zone_checking = undef,

) inherits dns::server::params {
  file { $default_file:
    ensure  => present,
    owner   => $::dns::server::params::owner,
    group   => $::dns::server::params::group,
    mode    => '0644',
    content => template("${module_name}/${default_template}"),
    notify  => Class['dns::server::service'],
    require => Package[$::dns::server::params::necessary_packages]
  }

}
