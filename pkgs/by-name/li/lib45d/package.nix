# original: https://discourse.nixos.org/t/import-problems-creating-a-new-package-45drives-autotier/22035/3?u=ckie
{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "lib45d";
  version = "unstable-2024-01-29";

  src = fetchFromGitHub {
    owner = "45Drives";
    repo = "lib45d";
    sha256 = "sha256-N/HC1OJe1Oa66KFdbIwIcCbV4Fi6FPSi0+KAtKJSjds=";
    rev = "a607e278182a3184c004c45c215aa22c15d6941d";
  };

  installFlags = [
    "LIB_PREFIX=/lib"
    "INCLUDE_PREFIX=/include"
    "DESTDIR=${placeholder "out"}"
    "DEVEL=TRUE"
  ];

  meta = with lib; {
    description = "45Drives C++ Library";
    homepage = "https://github.com/45Drives/lib45d";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    # TODO
    # maintainers =
  };
}
