{ domain, proxyURL, extraLoc ? "", extraMain ? "" } : (import ./reverse.nix {
  domain = domain;
  proxyURL = proxyURL;

  proxyWebsockets = true;
  recommendedProxySettings = true;

  extraLoc = ''
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    client_max_body_size 500G;
    proxy_read_timeout   600s;
    proxy_send_timeout   600s;
    send_timeout         600s;
  '' + extraLoc;
  extraMain = extraMain;
})
