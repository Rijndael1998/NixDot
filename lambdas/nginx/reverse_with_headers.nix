# TODO: This could call the reverse and then add on the extra config
{ domain, proxyURL, extraLoc ? "", extraMain ? "" } : {
  name = domain;
  value = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = proxyURL;
      proxyWebsockets = true;

      extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
      '' + extraLoc;
    };
    extraConfig = extraMain;
  };
}