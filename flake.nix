let
  hostname = import ./hostname.nix { };
in
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };
  outputs = { self, nixpkgs }: {
    # replace 'joes-desktop' with your hostname here.
    nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}