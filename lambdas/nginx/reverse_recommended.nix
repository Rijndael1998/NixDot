{ domain, proxyURL, extraLoc ? "", extraMain ? "" } : {
  name = domain;
  value = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = proxyURL;
      proxyWebsockets = true;
      recommendedProxySettings = true;

      extraConfig = extraLoc;
    };
    extraConfig = extraMain;
  };
}