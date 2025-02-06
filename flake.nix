{
  description = "A basic flake with a custom Linux kernel";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config = { allowUnfree = true; };
    };

    # Define the custom kernel package
    customKernel = pkgs.linuxPackagesFor (pkgs.linux_latest.override {
      argsOverride = rec {
        # src = ./linux; #local source linux_6.12.10.tar.xz
        src=pkgs.fetchFromGitHub {
          owner = "torvalds";
          repo = "linux";
          rev = "v6.12";
          sha256 = "";
        };
        version = "6.12.10";
        modDirVersion = "6.12.10";
      };
    });
  in {
    # Expose the custom kernel in the `packages` output 

    packages.x86_64-linux = rec {
      kernel = customKernel.kernel;  # Access the kernel derivation specifically
      default = kernel;             # Set the kernel as the default package
      stable = pkgs.callPackage ./stablelinux.nix { branch = "testing"; };
      testing = pkgs.linuxKernel.kernels.linux_6_13;
    };
    
    # a devshell to help me ensure dependencies are met
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = with pkgs;[ 
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




  };
}
