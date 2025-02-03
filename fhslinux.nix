{ pkgs ? import <nixpkgs> {} }:
(pkgs.buildFHSUserEnv {
  name = "kernel-env";
  targetPkgs = pkgs: with pkgs; [
    bc
    gcc
    flex
    bison
    openssl.dev
    elfutils.dev
    libelf
    ncurses.dev
  ];
}).env
