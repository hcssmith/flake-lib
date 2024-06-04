{mkFlake, ...}: {
  self,
  name,
  drv,
  ...
} @ args: let
  filteredArgs = builtins.removeAttrs args [
    "name"
    "drv"
  ];
in
  mkFlake (filteredArgs
    // {
      inherit self;
      packages = p: {
        default = drv p;
        ${name} = drv p;
      };
      overlay = final: prev: {
        ${name} = drv prev;
      };
    })
