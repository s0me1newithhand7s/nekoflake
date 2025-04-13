{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs : let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ] (system: function nixpkgs.legacyPackages.${system});
    in {
    packages = forAllSystems (pkgs:  {
      nekoray = pkgs.libsForQt5.callPackage pkgs/nekoray_3.26/package.nix {};
      nekobox = pkgs.callPackage pkgs/nekoray_4.0.1/package.nix {};
    });
    overlays = {
      default = final: prev: {
        nekoray = self.packages.nekoray;
        nekobox = self.packages.nekobox;
      };
    };
    checks = forAllSystems (pkgs: {
      default = pkgs.callPackage ./pkgs/checks.nix {};
    });
    formatter = forAllSystems ( pkgs.alejandra );
  };
}
