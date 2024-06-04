{
  nixpkgs,
  systems ? ["x86_64-linux"],
  ...
}: rec {
  mkFlake = import ./mkFlake.nix {inherit nixpkgs systems;};
  mkApp = import ./mkApp.nix {inherit mkFlake;};
}
