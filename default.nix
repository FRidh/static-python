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
  buildInterpreter = interpreter: (interpreter.override {
    rebuildBytecode = false;
    stripBytecode = true;
    x11Support = false; # TODO set to true to include tkinter
  }).overrideAttrs(oldAttrs: {
    patches = [];  # Remove Nix-specific patches
    passthru = {};  # No longer relevant
    postFixup = ''
      rm -rf $out/nix-support
    '';
  });

  buildTarball = attribute: interpreter: pkgs.runCommand "${attribute}.tar.gz" {
    buildInputs = with pkgs; [ gnutar gzip ];
  } ''
    tar -zcvf $out -C ${interpreter} .
  '';

  # Build interpreters for each of the listed attributes.
  interpreters = with pkgs.lib; listToAttrs (map (attribute: {name = attribute; value = buildInterpreter pkgs.pkgsStatic.${attribute};}) attributes);

  tarballs = pkgs.lib.mapAttrs buildTarball interpreters;

  # Cache the following build-time dependencies for CI
  cacheDeps = attribute: interpreter: pkgs.closureInfo {
    # It's better to use `nix-store -qR` but then we need to use cachix explicitly to push
    # This should be good enough
    rootPaths = interpreter.nativeBuildInputs ++ interpreter.propagatedBuildInputs;
  };

  depsToCache =  pkgs.lib.mapAttrsToList cacheDeps interpreters;

in {
  inherit interpreters tarballs depsToCache;
}
