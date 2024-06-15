{mkFlake, ...}: {
  drv,
  name,
  self,
  ...
} @ args: let
  filteredArgs = builtins.removeAttrs args [
    "drv"
    "name"
    "self"
  ];
in
  mkFlake (filteredArgs
    // {
      inherit self;
      overlay = final: prev: {
        ${name} = drv prev;
      };
      packages = p: {
        default = p.${name};
        ${name} = p.${name};
      };
    })
