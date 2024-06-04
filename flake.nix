{
  description = "Nix utilty functions for my personal flakes.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: {
    lib = import ./lib {inherit nixpkgs self;};
  };
}
