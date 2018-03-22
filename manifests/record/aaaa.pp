# == Define: dns::record::aaaa
#
# Wrapper of dns::record to set AAAA records
#
define dns::record::aaaa (
  String $zone,
  String $data,
  $ttl = '',
  String $host = $name ) {

  $alias = "${name},AAAA,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'AAAA',
    data   => $data
  }
}
