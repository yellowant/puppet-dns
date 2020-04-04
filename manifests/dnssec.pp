class dns::dnssec {
  file{'/etc/bind/dnssec-keys/':
    mode => "700",
    owner => "root",
    ensure => "directory"
  }
  file{'/opt/bump-dnssec':
    content => @(SCRIPT),
    #!/bin/bash
    shopt -s lastpipe
    BUMPED=false
    find /etc/bind/zones -name "*.unsigned" -mtime +14 | while read zone; do
      zone_name="${zone%.unsigned}"
      domain="${zone_name#/etc/bind/zones/db.}"
      printf "renewing: %s\n" "$domain"
      sed "8s/_SERIAL_/$(date +%s)/" "${zone_name}".stage.mixed > "${zone}"
      /usr/sbin/dnssec-signzone -o "$domain" -f "$zone_name" "$zone" /etc/bind/dnssec-keys/ksk-$domain/*.private  /etc/bind/dnssec-keys/zsk-$domain/*.private
      BUMPED=true
    done
    if [[ $BUMPED == true ]]; then
      printf "Reloading....\n"
      systemctl reload bind9
    fi
    | SCRIPT
    ensure => file,
    mode => "755",
  }->
  file{'/etc/systemd/system/bump-dnssec.service':
    content => @(UNIT),
    [Unit]
    Description=DNSSEC-Resign soon to expire zones.

    [Service]
    Type=oneshot
    ExecStart=/opt/bump-dnssec
    | UNIT
    ensure => file,
    notify => Exec['systemctl for bump-dnssec']
  }->
  file{'/etc/systemd/system/bump-dnssec.timer':
    content => @(UNIT),
    [Unit]
    Description=Run dnssec resign every 4 days

    [Timer]
    OnBootSec=15min
    OnUnitActiveSec=1day
    AccuracySec=1h
    Persistent=true
    [Install]
    WantedBy=timers.target
    | UNIT
    ensure => file,
  }~>
  exec{'systemctl for bump-dnssec':
    command => '/bin/systemctl daemon-reload',
    refreshonly => true
  }->
  service{'bump-dnssec.timer':
    enable => true,
    ensure => running
  }
    
}
