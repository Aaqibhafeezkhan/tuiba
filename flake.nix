{
  description = "tuiba, a Game Boy Advance emulator running in your terminal";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          isLinux = pkgs.stdenv.isLinux;
        in
        {
          default = pkgs.rustPlatform.buildRustPackage {
            pname = "tuiba";
            version = "0.16.0";
            src = self;
            cargoLock.lockFile = ./Cargo.lock;
            cargoBuildFlags = [ "-p" "tuiba" ];
            cargoTestFlags = [ "-p" "tuiba" ];
            nativeBuildInputs = [ pkgs.pkg-config ];
            buildInputs = pkgs.lib.optionals isLinux [
              pkgs.alsa-lib
              pkgs.udev
            ];
            meta = {
              description = "Game Boy Advance emulator running in your terminal";
              homepage = "https://github.com/Huseynteymurzade28/tuiba";
              license = pkgs.lib.licenses.mit;
              mainProgram = "tuiba";
              platforms = systems;
            };
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = [ pkgs.rustc pkgs.cargo pkgs.rustfmt pkgs.clippy pkgs.pkg-config ];
            buildInputs = pkgs.lib.optionals pkgs.stdenv.isLinux [
              pkgs.alsa-lib
              pkgs.udev
            ];
          };
        });
    };
}
