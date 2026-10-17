{
  description = "Llama Worker Twin for AI-enhanced mathematical reasoning";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          # Main package - copies lean source files for Lean build
          llama-worker-twin = pkgs.runCommand "llama-worker-twin" {
            src = builtins.path {
              path = ./lean-worker-twin;
              filter = path: type:
                (type == "regular" || type == "directory") &&
                (lib.hasSuffix ".lean" (toString path) ||
                 lib.hasSuffix ".toml" (toString path) ||
                 lib.hasSuffix ".nix" (toString path) ||
                 lib.hasSuffix ".md" (toString path));
            };
          } ''
            mkdir -p $out/src
            cp -r $src/src $out/
            cp -r $src/examples $out/
            cp $src/*.toml $out/
            cp $src/*.md $out/
            cp $src/*.nix $out/
          '';

          # Lean 4 with lake toolchain
          lean4 = pkgs.lean4;

          # Build with Lean
          llama-worker-twin-lean = pkgs.runCommand "llama-worker-twin-lean" {
            nativeBuildInputs = [ pkgs.lake pkgs.lean4 ];
          } ''
            mkdir -p $out
            cd $out
            cp -r ${./lean-worker-twin}/* .
            ln -s ${pkgs.lake}/bin/lake .
            ln -s ${pkgs.lean4}/bin/lean .
            lake update
            lake build
          '';
        };

        devShells = {
          default = pkgs.mkShell {
            name = "llama-worker-twin-dev";
            buildInputs = [
              pkgs.lake
              pkgs.lean4
              pkgs.cabal-install
              pkgs.ghc
              pkgs.python3
              pkgs.ruff
              pkgs.mypy
            ];
            shellHook = ''
              echo "🦙 Llama Worker Twin Development Environment"
              cd ${./lean-worker-twin}
              echo "  - Run: lake build"
              echo "  - Run: lake run basic_usage"
            '';
          };
        };

        checks = {
          build-check = pkgs.runCommand "build-check" { } ''
            cd ${./lean-worker-twin}
            ln -sf ${pkgs.lake}/bin/lake .
            ln -sf ${pkgs.lean4}/bin/lean .
            lake update
            lake build
            touch $out
          '';
        };
      });
}