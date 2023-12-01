{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lexical-lsp = {
      url = "git+file:///Users/logan/Projects/lexical";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    lexical-lsp,
    ...
  }: let
    inherit (nixpkgs) lib;
    withSystem = f:
      lib.fold lib.recursiveUpdate {}
      (map f ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]);
  in
    withSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (lexical-lsp.packages.${system}) lexical;
      in {
        devShells.${system}.default =
          pkgs.mkShell
          {
            packages = [pkgs.elixir lexical];
          };
      }
    );
}
