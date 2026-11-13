{
  description = "Linux terminal and user configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
    in
    {
      homeConfigurations.linux = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = builtins.currentSystem; };
        modules = [ ./home.nix ];
      };

      apps = nixpkgs.lib.genAttrs linuxSystems (system: {
        home-manager = {
          type = "app";
          program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
        };
      });
    };
}
