{ lib, stdenv, fetchFromGitHub, libglvnd, xorg }:

stdenv.mkDerivation rec {
  pname = "fmouse";
  version = "unstable-2022-02-26";

  src = fetchFromGitHub {
    owner = "ckiee";
    repo = "fmouse";
    rev = "ddac08e4088f72c969e6c429f4b646a268d2fb8f";
    sha256 = "sha256-FnNAOLzmUUSqTrQlRSFz2NIqiMJQE2TBmWSJnzvCVlg=";
  };

  buildInputs = [
    libglvnd
    xorg.libXinerama
    xorg.libXext
    xorg.libX11
    xorg.libXtst
    xorg.libXi
  ];

  installPhase = ''
    mkdir -p $out/bin
    install fmouse $out/bin/fmouse
  '';

  meta = with lib; {
    description = "Keyboard-based virtual mouse navigation for X11";
    homepage = "https://github.com/ckiee/fmouse";
    maintainers = with maintainers; [ ckie ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
