# overlays/custom-kernel.nix
self: super: {
  linux_custom = super.linuxPackages_latest.kernel.overrideAttrs (old: rec {
    version = "6.12.10";
    src = ./linux;
  });
}
