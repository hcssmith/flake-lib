{
  description = "Nix utilty functions for my personal flakes.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  }: let
    lib = import ./lib {
      inherit nixpkgs;
      systems = import systems;
    };
  in
    lib.mkFlake {
      inherit self;
      overlay = final: prev: {
        generate-systems = prev.writeShellScriptBin "generate-systems" ''
          nix-instantiate --json --eval --expr "with import <nixpkgs> {}; lib.platforms.all" | jq 'sort' | sed 's!,!!' > allSystems.nix
        '';
      };
      packages = p: {generate-systems = p.generate-systems;};
    };
}
