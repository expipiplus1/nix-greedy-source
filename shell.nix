{ pkgs ? import <nixpkgs> { } }:

let
  src = ./.;

  # Generate a haskell derivation using the cabal2nix tool on `package.yaml`
  drv = pkgs.haskellPackages.callCabal2nix "" src { };

in pkgs.haskellPackages.shellFor { packages = _: [ drv ]; }
