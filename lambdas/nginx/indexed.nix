
domain : {
  name = domain;
  value = {
    enableACME = true;
    forceSSL = true;
    root = "/var/www/html";
    extraConfig = ''
      autoindex on;
      autoindex_exact_size off;
      autoindex_format html;
      autoindex_localtime on;
    ''
  };
}