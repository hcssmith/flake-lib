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
        default = drv p;
        ${name} = drv p;
      };
      overlay = final: prev: {
        ${name} = drv prev;
      };
    })
