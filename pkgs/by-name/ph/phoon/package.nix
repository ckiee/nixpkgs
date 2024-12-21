{
  lib,
  stdenv,
  fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "phoon";
  version = "unstable-2024-12-21";

  src = fetchFromGitHub {
    owner = "ckiee";
    repo = "phoon";
    rev = "d3cf583b2e548ef6a782afdf605d80c7cbbba8c3";
    hash = "sha256-1Wh2dlH7GmkYzquWW/KQPB7vk/SdnuU1HptI9LpYHQU=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
  preBuild = ''
    makeFlagsArray+=(CC="$CC")
  '';

  meta = with lib; {
    description = "display the current moon phase";
    homepage = "https://github.com/ckiee/phoon";
    license = licenses.free;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "phoon";
  };
}
