with import <nixpkgs> {};
{
     testEnv = stdenv.mkDerivation {
       name = "linux-kernel-dev-env";
       buildInputs = [
           stdenv
           git
           gnumake
           ncurses
           bc
           flex
           bison
           elfutils
           openssl
           qemu_full
           debootstrap
           gcc
           gdb
           clang_16
           clang-tools_16
           lld_16
           llvmPackages_16.libllvm
       ];
     };
}
