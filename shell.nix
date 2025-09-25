{ system ? builtins.currentSystem }:
let
	sources = import ./npins;
	pkgs = import sources.nixpkgs { inherit system; config = {}; overlays = []; };
in pkgs.mkShellNoCC {
	NIX_CONFIG = "extra-experimental-features = nix-command";
  NIX_PATH = "nixpkgs=${pkgs.path}";
  
  packages = with pkgs; [
    git
    npins
  ];
}
