{ domain, proxyURL, extraLoc ? "", extraMain ? "", key ? "${domain}" } : {
  name = domain;
  value = {
    enableACME = false;
    forceSSL = true;

    sslCertificate = "/etc/keys/nginx/${key}.pem";
    sslCertificateKey = "/etc/keys/nginx/${key}.key" ;

    locations."/" = {
      proxyPass = proxyURL;
      proxyWebsockets = true;

      extraConfig = extraLoc;
    };
    extraConfig = extraMain;
  };
}
