let
  nixpkgs = fetchTarball https://github.com/NixOS/nixpkgs/archive/947d81c8e68eeeb68e4c26181670b0415b8c3876.tar.gz;
  pkgs = import nixpkgs {};

  # Interpreters to build. These correspond to attributes in Nixpkgs.
  attributes = [
    #"python36"
    "python37"
    "python38"
    "python39"
  ];

  # Build an interpreter by overriding the Nixpkgs recipe.
  buildInterpreter = interpreter: interpreter.override {
    rebuildBytecode = false;
    stripBytecode = true;
    x11Support = false; # TODO set to true to include tkinter
  };

  # Build interpreters for each of the listed attributes.
  interpreters = with pkgs.lib; listToAttrs (map (attribute: {name = attribute; value = buildInterpreter pkgs.pkgsStatic.${attribute};}) attributes);

in {
  inherit interpreters;
}
