# == Define dns::zone
#
# `dns::zone` defines a DNS zone and creates both the zone entry
# in the `named.conf` files and the standardized zone file header
# to which the zone records will be added.
#
# === BIND Time Values
#
# BIND time values are numeric strings and default to representing a
# number of seconds (e.g. a time value of `3600` equals one hour).
# Time values may optionally be followed by a suffix of `m`, `h`,
# `d`, or `w`, meaning the time is in minutes, hours, days, or weeks,
# respectively.  For example, one week could be represented as any of
# `1w`, `7d`, `168h`, `10080m`, or `604800`.
#
# === FQDN Values
#
# The `dns::zone` type will append the final `.` dot to any value which
# is listed in the *Parameters* section as an *FQDN* (Fully Qualified
# Domain Name).  This has two implications:  First, any FQDN must *not*
# include the trailing `.` dot; second, any parameter listed as an FQDN
# _must_ be fully-qualified, and will not allow the hostname-only form
# of the name (e.g. in the `example.net` domain, `ns1.example.net` could
# not be referred to as `ns1` in any parameter that requires an FQDN).
#
# === Access Control Lists
#
# Any parameter which is an Access Control List is an array that may
# contain the pre-defined ACL names `none`, `any`, `localhost`, or
# `localnets`, or may contain ip addresses, optionally precededed by a
# `!` exclamation mark and optionally followed by a `/` and a prefix
# length for a subnet match.
#
# === Parameters
#
# [*allow_transfer*]
#   An array that indicates what other DNS servers may initiate a
#   zone transfer of this zone.  The array may contain IP addresses,
#   optionally followed by a `/` and a prefix length for a subnet match,
#   and optionally prefixed by a `!` exclamation mark (to indicate that
#   the IP address - or addresses, with a subnet match - are denied
#   rather than allowed) or the special ACL names `any`, `localhost`,
#   `localnets`, or `none`: `any` matches any host; `localhost` matches
#   only the name server itself; `localnets` matches the name server
#   and any request from the name server's subnet(s); and `none` is the
#   equivalent of `!any` - it denies all requests.  The first entry in
#   the array that matches the requester's address will be used.
#
# [*allow_forwarder*]
#   An array of IP addresses and optional port numbers to which queries
#   for this zone will be forwarded (based on the *forward_policy*
#   setting).  If the optional port number is included, it must be
#   separated from the IP address by the word `port` - for example, `[
#   '192.168.100.102 port 1234' ]`.  Defaults to an empty array, which
#   means no forwarding will be done.
#
# [*allow_query*]
#   An array of IP addresses from which queries should be allowed
#  Defaults to an empty array, which allows all ip to query the zone
#
# [*allow_update*]
#   An array of IP addresses from which updates should be allowed.
#  Defaults to an empty array, which allows updates to the zone.
#  If Array has entries, then zone file initial creation is allowed
#  but content will not be replaced. This capability allows dynamic
#  updates.
#
# [*also_notify*]
#   This is an array of IP addresses and optional port numbers to
#   which this DNS server will send notifies when the master DNS server
#   reloads the zone file.  See the *allow_forwarder* parameter for how
#   to include the optional port numbers.
#
# [*data_dir*]
#   Bind data directory.
#   Default: /etc/bind/zones
#
# [*forward_policy*]
#   Either `first` or `only`.  If the *allow_forwarder* array is not
#   empty, this setting defines how query forwarding is handled.  With a
#   value of `only`, the DNS server will forward the request and return
#   the response to the client immediately.  With a value of `first`,
#   the DNS server will forward the request; if the forwarder server
#   returns a not-found response, the DNS server will attempt to answer
#   the request itself.
#
# [*nameservers*]
#   An array containing the FQDN's of each name server for this zone.
#   This will be used to create the `NS` records for the zone file.
#   Defaults to an array containing the `$::fqdn` fact.
#
# [*reverse*]
#   If `true`, the zone will have `.in-addr.arpa` appended to it.
#   If set to the string `reverse`, the `.`-separated components of
#   the zone will be reversed, and then have `.in-addr.arpa` appended
#   to it.
#   Defaults to `false`.
#
# [*serial*]
#   Optional set or time bases auto generated serial numver of zone file
#
# [*slave_masters*]
#   If *zone_type* is set to `slave` or `stub`, this holds an array or string
#   containing the IP addresses of the DNS servers from which this slave
#   transfers the zone.  If a string, the IP addresses must be separated
#   by semicolons (`;`).
#
# [*soa*]
#   The authoritative name server for this zone.  Defaults to the
#   `$::fqdn` fact.
#
# [*soa_email*]
#   The point-of-contact authoritative name server for this zone, in
#   the form _<username>_`.`_<domainname>_ (_<username>_ may not contain
#   `.` dots).  Defaults to `root.` followed by the `$::fqdn` fact.
#
# [*zone_expire*]
#   This is the maximum amount of time after the last successful refresh
#   of the zone for which the slave will continue to respond to DNS
#   queries for records in this zone.
#
# [*zone_minimum*]
#   Despite _minimum_ in the parameter name, this is the maximum time
#   that a _negative_ for this zone (e.g. a host not found response)
#   may be cached by other resolvers.
#
# [*zone_notify*]
#   One of `yes`, `no`, or `explicit`.   With a value of `explicit`,
#   when sending notifies, the DNS server will send them only to the
#   slaves listed in the `also_notify` list.  With `yes`, the DNS server
#   will send notifies to the `also_notify` list _and_ to all nameservers
#   listed in the `NS` records for the zone _except_ for the nameserver
#   listed in the `soa` parameter and the sending name server.  With `no`,
#   the DNS server will never send notifies for this zone.
#
# [*zone_refresh*]
#   The minimum time between when slaves will check back with the zone
#   master(s) to check if the zone has been updated.  See *Time values*
#   above.  Defaults to 604800 seconds (7 days).
#
# [*zone_retry*]
#   If a slave tries and fails to contact the master(s), this is the
#   time the slave will wait before retrying.
#
# [*zone_ttl*]
#   The default TTL (time-to-live) for the zone records.  See *Time
#   values* above.  Defaults to 604800 seconds (7 days).
#
# [*zone_type*]
#   The type of DNS zone being described.  Can be one of `master`, `slave`
#   (requires *slave_masters* to be set), `stub` (requires *slave_masters*
#   to be set), `delegation-only`, or `forward` (requires both
#   *allow_forwarder* and *forward_policy* to be set).
#   Defaults to `master`.
#
class dns::dnssec {
  file{'/etc/bind/dnssec-keys/':
    mode => "700",
    owner => "root",
    ensure => "directory"
  }
}
define dns::zone (
  $soa = $::fqdn,
  $soa_email = "root.${::fqdn}",
  Integer $zone_ttl = 604800,
  Integer $zone_refresh = 604800,
  Integer $zone_retry = 86400,
  Integer $zone_expire = 2419200,
  Integer $zone_minimum = 604800,
  Array[String] $nameservers = [ $::fqdn ],
  Boolean $reverse = false,
  Boolean $serial = false,
  Enum['master', 'slave', 'stub', 'forward', 'delegation-only'] $zone_type = 'master',
  Array[Stdlib::IP::Address] $allow_transfer = [],
  Array[Stdlib::IP::Address] $allow_forwarder = [],
  Array[Stdlib::IP::Address] $allow_query =[],
  Array[Stdlib::IP::Address] $allow_update =[],
  Enum['first', 'only'] $forward_policy = 'first',
  $slave_masters = undef,
  Variant[Enum['yes', 'no', 'explicit', 'master-only'], Undef] $zone_notify = undef,
  Array[String] $also_notify = [],
  $ensure = present,
  $data_dir = $::dns::server::params::data_dir,
  Boolean $dnssec = false,
) {

  $cfg_dir = $dns::server::params::cfg_dir

  $zone = $reverse ? {
    'reverse' => join(reverse(split("arpa.in-addr.${name}", '\.')), '.'),
    true      => "${name}.in-addr.arpa",
    default   => $name
  }

  $zone_file = "${data_dir}/db.${name}"
  $zone_file_stage = "${zone_file}.stage"

  # Replace when updates allowed
  if empty($allow_update) {
    $zone_replace = true
  } else {
    $zone_replace = false
  }

  if $ensure == absent {
    file { $zone_file:
      ensure => absent,
    }
  } elsif $zone_type == 'master' {
    # Zone Database

    # Create "fake" zone file without zone-serial
    concat { $zone_file_stage:
      owner   => $dns::server::params::owner,
      group   => $dns::server::params::group,
      mode    => '0644',
      replace => $zone_replace,
      require => Class['dns::server'],
      notify  => Exec["bump-${zone}-serial"]
    }
    concat::fragment{"db.${name}.soa":
      target  => $zone_file_stage,
      order   => 1,
      content => template("${module_name}/zone_file.erb")
    }

    # Generate real zone from stage file through replacement _SERIAL_ template
    # to current timestamp. A real zone file will be updated only at change of
    # the stage file, thanks to this serial is updated only in case of need.

    $zone_serial = $serial ? {
      false   => inline_template('<%= Time.now.to_i %>'),
      default => $serial
    }
    if $dnssec {
      include dns::dnssec
      file{"/etc/bind/dnssec-keys/zsk-${zone}/":
        ensure => directory
      } ~>
      exec{"gen-zsk-${zone}":
        command => '/usr/sbin/dnssec-keygen -3 $domain',
        cwd => "/etc/bind/dnssec-keys/zsk-${zone}/",
        refreshonly => true,
        environment => ["domain=${zone}"]
      }
      file{"/etc/bind/dnssec-keys/ksk-${zone}/":
        ensure => directory
      } ~>
      exec{"gen-ksk-${zone}":
        command => '/usr/sbin/dnssec-keygen -3 -fk $domain',
        cwd => "/etc/bind/dnssec-keys/ksk-${zone}/",
        refreshonly => true,
        environment => ["domain=${zone}"]
      }
      exec{"mix-zone-${zone}":
        require => [Exec["gen-zsk-${zone}"], Exec["gen-ksk-${zone}"]],
        command => '/bin/cat -- "$zf" /etc/bind/dnssec-keys/*sk-$domain/*.key > "$zf.mixed"',
        provider => shell,
        user        => "root",
        cwd => "/etc/bind/dnssec-keys/ksk-${zone}/",
        refreshonly => true,
        environment => ["domain=${zone}", "zf=$zone_file_stage"],
        subscribe => Concat[$zone_file_stage],
        notify => Exec["bump-${zone}-serial"]
      }
      exec{"sign-zone-${zone}":
        command => '/usr/sbin/dnssec-signzone -o "$domain" -f "$zfo" "$zf" /etc/bind/dnssec-keys/ksk-$domain/*.private  /etc/bind/dnssec-keys/zsk-$domain/*.private',
        refreshonly => true,
        provider    => shell,
        user        => "root",
        environment => ["domain=${zone}", "zf=${zone_file}.unsigned", "zfo=${zone_file}"],
        subscribe   => Exec["bump-${zone}-serial"],
        notify      => Class['dns::server::service']
      }
      $zone_staged = "${zone_file_stage}.mixed"
      $zone_stage_out = "${zone_file}.unsigned"
    } else {
      $zone_staged = $zone_file_stage
      $zone_stage_out = $zone_file
    }
    exec { "bump-${zone}-serial":
      command     => "sed '8s/_SERIAL_/${zone_serial}/' ${zone_staged} > ${zone_stage_out}",
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      refreshonly => true,
      provider    => posix,
      user        => $dns::server::params::owner,
      group       => $dns::server::params::group,
      require     => Class['dns::server::install'],
      notify      => Class['dns::server::service'],
    }
  } else {
    # For any zone file that is not a master zone, we should make sure
    # we don't have a staging file
    concat { $zone_file_stage:
      ensure => absent
    }
  }

  # Include Zone in named.conf.local
  concat::fragment{"named.conf.local.${name}.include":
    target  => "${cfg_dir}/named.conf.local",
    order   => 3,
    content => template("${module_name}/zone.erb")
  }

}
