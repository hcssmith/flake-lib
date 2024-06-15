{mkFlake, ...}: {
  drv,
  name,
  self,
  ...
} @ args: let
  filteredArgs = builtins.removeAttrs args [
    "drv"
    "name"
  ];
in
  mkFlake (filteredArgs
    // {
      inherit self;
      packages = p: {
        default = p.${name};
        ${name} = p.${name};
      };
      overlay = final: prev: {
        ${name} = drv prev;
      };
    })
