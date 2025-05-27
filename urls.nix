{}: {
    stable = fetchTarball { 
        url = "https://github.com/NixOS/nixpkgs/archive/25.05.tar.gz";
    };

    unstable = fetchTarball { 
        url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
    };
}