{ pkgs, unstable }: 
let
  audio = import ./templates/audio.nix {inherit pkgs;};
  essential = import ./templates/essential.nix {inherit pkgs;};
  finance = import ./templates/finance.nix {inherit pkgs;};
  fun = import ./templates/fun.nix {inherit pkgs; inherit unstable;};
  office = import ./templates/office.nix {inherit pkgs; inherit unstable;};
  pentest = import ./templates/pentest.nix {inherit pkgs;};
  programming = import ./templates/programming.nix {inherit pkgs;inherit unstable;};
  social = import ./templates/social.nix {inherit pkgs;};
  socialLower = import ./templates/socialLower.nix {inherit pkgs;};
  util = import ./templates/util.nix {inherit pkgs;inherit unstable;};
in

with pkgs;
[] ++ 
audio ++
essential ++ 
finance ++
fun ++
office ++ 
pentest ++
programming ++ 
social ++ 
socialLower ++ 
util ++
[]
