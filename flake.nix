{
  description = "continuous-release/nix — Nix build-system testbed";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
      version = nixpkgs.lib.removeSuffix "\n" (builtins.readFile ./version.txt);
    in {
      packages = forAllSystems (pkgs: {
        default = pkgs.rustPlatform.buildRustPackage {
          pname = "continuous-release-nix";
          inherit version;
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
          RELEASE_VERSION = version;
          doCheck = true;
        };
      });

      checks = forAllSystems (pkgs: {
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
      });

      apps = forAllSystems (pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/continuous-release-nix";
        };
      });
    };
}
