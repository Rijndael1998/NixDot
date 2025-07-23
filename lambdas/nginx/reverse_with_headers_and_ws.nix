{ domain, proxyURL, extraLoc ? "", extraMain ? "" } : (import ./reverse_recommended.nix {
  domain = domain;
  proxyURL = proxyURL;
  extraLoc = ''
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    client_max_body_size 100000G;
    proxy_read_timeout   600s;
    proxy_send_timeout   600s;
    send_timeout         600s;
  '' + extraLoc;
  extraMain = extraMain;
})
