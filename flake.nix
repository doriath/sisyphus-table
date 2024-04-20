{
  description = "Flake for sisyphus-table project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rust = pkgs.rust-bin.stable.latest.default.override {
          targets = ["thumbv6m-none-eabi"];
        };
        rustPlatform = pkgs.recurseIntoAttrs (pkgs.makeRustPlatform {
          rustc = rust;
          cargo = rust;
        });
      in
      rec
      {
        formatter = pkgs.nixpkgs-fmt;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.bashInteractive
            pkgs.rust-analyzer
            pkgs.udev
            pkgs.pkg-config
            rust
          ];
        };
      }
    );
}
