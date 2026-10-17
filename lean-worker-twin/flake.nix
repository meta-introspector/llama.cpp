{
  description = "Llama.cpp Lean Worker Twin for Mathematical Reasoning";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Link to lean-workers-union for submission when ready
    lean-workers-union = {
      url = "github:lean-workers-union/lean-workers-union";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, lean-workers-union }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        lean = pkgs.lean4;
      in {
        packages = {
          # Build the lean worker twin module
          llama-worker-twin = pkgs.runCommand "llama-worker-twin" { } ''
            mkdir -p $out
            cp -r $src/* $out/
            chmod +x $out/examples/*.lean
            touch $out
          '';
        };

        devShells.default = pkgs.mkShell {
          name = "llama-worker-twin-dev";
          buildInputs = [
            pkgs.gcc
            pkgs.cmake
            pkgs.make
            pkgs.git
            pkgs.python3
            pkgs.ruff
            pkgs.mypy
            pkgs.lean4
            pkgs.lake
          ];
          shellHook = ''
            echo "🦙 Llama Worker Twin Development Environment"
            echo "  - Build: nix build .#llama-worker-twin"
            echo "  - Test: cd examples && lake build"
            echo "  - Run: cd examples && lake run basic_usage"
          '';
        };

        checks = {
          test = pkgs.runCommand "test" { } ''
            cd $src/examples
            lake build
            touch $out
          '';
        };
      });
}