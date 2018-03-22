# == Define dns::record::dname
#
# Wrapper for dns::record to set a CNAME
#
define dns::record::cname (
  String $zone,
  String $data,
  $ttl = '',
  String $host = $name) {

  $alias = "${name},CNAME,${zone}"

  $qualified_data = $data ? {
    '@'     => $data,
    /\.$/   => $data,
    default => "${data}."
  }

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'CNAME',
    data   => $qualified_data
  }
}
