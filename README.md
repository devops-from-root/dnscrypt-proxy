# DNSCrypt-proxy как сервис docker compose

* остановить и удалить текущий сервис DNS: `systemctl stop systemd-resolved && systemctl disable systemd-resolved`;

* установить настройки системного резолвера `echo -e "nameserver 127.0.0.1\noptions $(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)" > /etc/resolv.conf && chattr +i /etc/resolv.conf`;

* запустить сервис `docker compose up -d --build`;

* в файле /etc/docker/dsemon.json установить `"dns": ["127.0.0.1"]`;
