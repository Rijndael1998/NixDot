{ pkgs, unstable }: 
let
  essential = import ./templates/essential.nix {inherit pkgs;};
  office = import ./templates/office.nix {inherit pkgs; inherit unstable;};
  programming = import ./templates/programming.nix {inherit pkgs;};
  util = import ./templates/util.nix {inherit pkgs;inherit unstable;};
  social = import ./templates/social.nix {inherit pkgs;};
  socialLower = import ./templates/socialLower.nix {inherit pkgs;};
  fun = import ./templates/fun.nix {inherit pkgs; inherit unstable;};
  pentest = import ./templates/pentest.nix {inherit pkgs;};
  finance = import ./templates/finance.nix {inherit pkgs;};
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
finance ++
[]
