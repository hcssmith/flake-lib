{
  nixpkgs,
  systems ? ["x86_64-linux"],
  self,
  ...
}: rec {
  mkFlake = import ./mkFlake.nix {inherit nixpkgs systems self;};
  mkApp = import ./mkApp.nix {inherit mkFlake;};
}
