{ pkgs }: 
let
  essential = import ./templates/essential.nix {inherit pkgs;};
  office = import ./templates/office.nix {inherit pkgs;};
  programming = import ./templates/programming.nix {inherit pkgs;};
  util = import ./templates/util.nix {inherit pkgs;};
  social = import ./templates/social.nix {inherit pkgs;};
  socialLower = import ./templates/socialLower.nix {inherit pkgs;};
  fun = import ./templates/fun.nix {inherit pkgs;};
  pentest = import ./templates/pentest.nix {inherit pkgs;};
in

with pkgs;
[] ++ 
essential ++ 
office ++ 
programming ++ 
util ++
social ++ 
socialLower ++ 
fun ++
pentest ++
[]
