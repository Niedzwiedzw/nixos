{lib, ...}: let
  udpPort = 51820;
  privateKeyFile = "/home/niedzwiedz/.wireguard/private";
  serverPublicKey = "NkBpoKIa1SAI3bk6SmPvb1TW7jzSWXvHLjDSNl8UUTg=";
  serverIpAddress = lib.concatStrings ["165." "22." "84." "176"];
  myAddress = "192.1.2.2";
in {
  networking.firewall = {
    allowedUDPPorts = [udpPort]; # Clients and peers can use the same port, see listenport
  };
  # Enable WireGuard
  networking.wg-quick.interfaces = {
    wgbosch = {
      address = ["${myAddress}/32"];
      privateKeyFile = privateKeyFile;

      peers = [
        {
          publicKey = serverPublicKey;
          allowedIPs = ["192.1.2.0/24"];
          endpoint = "${serverIpAddress}:${toString udpPort}";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
