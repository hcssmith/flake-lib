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
  }: {
    lib = import ./lib {
      inherit nixpkgs self;
      systems = import systems;
    };
  };
}
