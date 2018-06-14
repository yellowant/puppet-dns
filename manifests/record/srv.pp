# == Define dns::server:srv
#
# Wrapper for dns::zone to set SRV records
#
define dns::record::srv (
  $zone,
  String $host = '@',
  String $service,
  Integer $pri,
  Integer $weight,
  Integer $port,
  String $target,
  Enum['tcp', 'udp'] $proto = 'tcp',
  $ttl = '',
) {

  $alias = "${service}:${proto}@${target}:${port},${pri},${weight},SRV,${zone}"

  if($host == '@'){
    $host2 = "_${service}._${proto}"
  }else{
    $host2 = "_${service}._${proto}.${host}"
  }

  dns::record { $alias:
    zone   => $zone,
    host   => $host2,
    ttl    => $ttl,
    record => 'SRV',
    data   => "${pri}\t${weight}\t${port}\t${target}"
  }
}
