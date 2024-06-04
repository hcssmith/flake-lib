{
  nixpkgs,
  systems,
  ...
}: rec {
  allSystems = import ../allSystems.nix;
  system = builtins.listToAttrs (map (s: {
      name = s;
      value = s;
    })
    allSystems);
  mkFlake = import ./mkFlake.nix {inherit nixpkgs systems;};
  mkApp = import ./mkApp.nix {inherit mkFlake;};
}
