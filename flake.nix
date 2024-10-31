{
  description = "A flake for cl-skkserv";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    papyrus.url = "github:tani/papyrus/pod";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    systems,
    papyrus,
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;
      perSystem = {pkgs, system, ...}: let
        pname = "cl-skkserv";
        version = "0.9.0";
        lispLib = pkgs.sbcl.buildASDFSystem {
          inherit pname version;
          src = ./.;
          systems = [
            pname
            "${pname}/cli"
            "${pname}/test"
          ];
          lispLibs = with pkgs.sbcl.pkgs; [
            _1am
            alexandria
            cl-ppcre
            esrap
            portable-threads
            jp-numeral
            drakma
            flexi-streams
            yason
            named-readtables
            babel
            trivial-download
            usocket
            usocket-server
            daemon
            unix-opts
          ] ++ [papyrus.packages."${system}".default];
        };
        lispApp = pkgs.sbcl.withPackages (ps: [lispLib]);
        main = pkgs.writeShellScriptBin "${pname}-main" ''
          ${lispApp}/bin/sbcl --noinform --non-interactive --eval "(require :asdf)" --eval "(asdf:load-system :${pname}/cli)" --eval "(${pname}/cli:entry-point)" "$@"
        '';
        test = pkgs.writeShellScriptBin "${pname}-test" ''
          ${lispApp}/bin/sbcl --noinform --non-interactive --eval "(require :asdf)" --eval "(asdf:test-system :${pname})"
        '';
      in {
        packages.default = lispLib;
        devShells.default = pkgs.mkShell {
          packages = [lispApp];
        };
        apps = {
          default = {
            type = "app";
            program = main;
          };
          test = {
            type = "app";
            program = test;
          };
        };
      };
    };
}
