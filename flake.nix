{
  description = "HasCallStack Example";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs =
    { flake-compat
    , flake-utils
    , nixpkgs
    , self
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      buildTools = c: with c; [
        cabal-install
        haskell-language-server
        pkgs.zlib
      ];
      ghc-version = "ghc944";
      compiler = pkgs.haskell.packages."${ghc-version}";
      mkPkg = returnShellEnv:
        compiler.developPackage {
          inherit returnShellEnv;
          name = "hcs-class";
          root = ./.;
          modifier = drv:
            pkgs.haskell.lib.addBuildTools drv (buildTools compiler);
        };
    in
    {
      packages.default = mkPkg false;
      devShells.default = mkPkg true;
    });
}
