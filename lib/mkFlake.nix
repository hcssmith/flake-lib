{
  nixpkgs,
  systems,
  self,
}: let
  defaults = {
    packages = p: {default = p.hello;};
    formatter = p: p.alejandra;
    devShells = p:
      with p; {
        default = mkShell {
          nativeBuildInputs = [nix-prefetch-github];
          shellHook = "zsh";
        };
      };
    overlays = [self.overlays.default];
    overlay = final: prev: {};
    nixConfig = {
      allowUnfree = true;
    };
  };
in
  {
    overlay ? defaults.overlay,
    overlays ? defaults.overlays,
    nixConfig ? defaults.nixConfig,
    packages ? defaults.packages,
    formatter ? defaults.formatter,
    devShells ? defaults.devShells,
    ...
  } @ args: let
    forAllSystems = nixpkgs.lib.genAttrs systems;
    genOverlay = dir: final: prev: (
      nixpkgs.lib.genAttrs (builtins.attrNames (builtins.readDir dir)) (
        name: prev.callPackage /${dir}/${name} {inherit prev;}
      )
    );
    filteredArgs = builtins.removeAttrs args [
      "overlay"
      "overlays"
      "nixConfig"
      "packages"
      "formatter"
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
    {
      packages = forAllSystems (system: (packages nixPkgsFor.${system}));
      formatter = forAllSystems (system: (formatter nixPkgsFor.${system}));
      devShells = forAllSystems (system: (devShells nixPkgsFor.${system}));
      overlays.default =
        if (builtins.isPath overlay)
        then genOverlay overlay
        else overlay;
    }
    // filteredArgs
