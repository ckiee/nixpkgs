# original: https://discourse.nixos.org/t/import-problems-creating-a-new-package-45drives-autotier/22035/3?u=ckie
{ lib, stdenv, fetchFromGitHub, fuse3, lib45d, boost, which, perl, rocksdb, tbb }:


# let
#   boost_static = boost.override { enableStatic = true; };
stdenv.mkDerivation rec {
  pname = "autotier";
  version = "unstable-2024-08-08";

  src = fetchFromGitHub {
    owner = "45Drives";
    repo = "autotier";
    sha256 = "sha256-XNM82yYwh3xapj3Euy++v0eKR1RVru9idOJzuKWBfIo=";
    rev = "c994ce18d0b864bc003c74345ed65464b6bf8be0";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ which perl ];
  buildInputs = [ fuse3 lib45d boost rocksdb tbb ];

  enableParallelBuilding = true;

  patches = [
    # Added missing includes (for uintmax_t, ofstream)
    # https://github.com/45Drives/autotier/pull/70
    ./0001-Add-missing-includes.patch
    # disable vendored rocksdb build
    ./0002-remove-rocksdb-vendored-build.patch
    # link to boost dynamically for CLI
    ./0003-link-to-boost-dynamically-for-CLI.patch
  ];

  postPatch = ''
    patchShebangs src/rocksdb/build_tools
  '';

  # uses <fuse.h> but we need <fuse3/fuse.h>
  # needs a push to find rocksdb, no pkg-config
  NIX_CFLAGS_COMPILE = "-I${fuse3}/include/fuse3 -I${rocksdb}/include";

  installFlags = [ "DESTDIR=${placeholder "out"}" "PACKAGING=1"];

  meta = with lib; {
    description = "A multi tiered storage solution";
    longDescription = ''
      A passthrough FUSE filesystem that intelligently moves files between
      storage tiers based on frequency of use, file age, and tier fullness.
    '';
    homepage = "https://github.com/45Drives/autotier";
    license = with licenses; [ gpl3 ];
    platforms = platforms.unix;
  };
}
