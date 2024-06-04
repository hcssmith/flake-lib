{
  nixpkgs,
  systems,
}: {
  devShells ? p:
    with p; {
      default = mkShell {
        nativeBuildInputs = [nix-prefetch-github];
        shellHook = "zsh";
      };
    },
  formatter ? p: p.alejandra,
  nixConfig ? {allowUnfree = true;},
  overlay ? final: prev: {},
  overlays ? [self.overlays.default],
  packages ? p: {default = p.hello;},
  self,
  ...
} @ args: let
  forAllSystems = nixpkgs.lib.genAttrs systems;
  genOverlay = dir: final: prev: (
    nixpkgs.lib.genAttrs (builtins.attrNames (builtins.readDir dir)) (
      name: prev.callPackage /${dir}/${name} {inherit prev;}
    )
  );
  filteredArgs = builtins.removeAttrs args [
    "devShells"
    "formatter"
    "nixConfig"
    "overlay"
    "overlays"
    "packages"
    "self"
  ];

  nixPkgsFor = forAllSystems (
    system:
      import nixpkgs {
        inherit system;
        overlays = overlays;
        config = nixConfig;
      }
  );
in
  filteredArgs
  // {
    devShells = forAllSystems (system: (devShells nixPkgsFor.${system}));
    formatter = forAllSystems (system: (formatter nixPkgsFor.${system}));
    overlays.default =
      if (builtins.isPath overlay)
      then genOverlay overlay
      else overlay;
    packages = forAllSystems (system: (packages nixPkgsFor.${system}));
  }
