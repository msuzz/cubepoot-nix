{
  description = "The Suz Special";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, ... }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        cubepoot = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            { _module.args = inputs; }
            ./configuration.nix
          ];
        };
      };
    };
}



