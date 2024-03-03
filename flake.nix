{
  description = "Rust dev using fenix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
          ];
        };
      in {
        devShell = pkgs.mkShell.override {} {
          # build environment
          nativeBuildInputs = with pkgs;
            [
            ]
            ++ lib.optionals pkgs.stdenv.isLinux
            [
            ];

          # runtime environment
          buildInputs = with pkgs;
            [
              python311
              python311Packages.pip
              python311Packages.virtualenv
            ]
            ++ lib.optionals pkgs.stdenv.isDarwin [
            ];
        };

        defaultPackage = pkgs.mkRustPackage {
          cargoSha256 = "46652094fc5f1f00761992c876b6712052edd15eefd93b2e309833a30af94a95";
          src = ./.;
        };
      }
    );
}
