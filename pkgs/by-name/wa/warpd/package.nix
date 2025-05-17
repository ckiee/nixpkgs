{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  withWayland ? true,
  cairo,
  libxkbcommon,
  wayland,
  withX ? false, /* BORK ; unstable */
  libXi,
  libXinerama,
  libXft,
  libXfixes,
  libXtst,
  libX11,
  libXext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "warpd";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "warpd";
    rev = "01650eabf70846deed057a77ada3c0bbb6d97d6e";
    sha256 = "sha256-kNoaOfDXsiQc2yGVgYK/iS8azP2jgoX1g4v9ZrgLYUI=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ git ];

  buildInputs =
    lib.optionals withWayland [
      cairo
      libxkbcommon
      wayland
    ]
    ++ lib.optionals withX [
      libXi
      libXinerama
      libXft
      libXfixes
      libXtst
      libX11
      libXext
    ];

  makeFlags = [
    "PREFIX=$(out)"
  ]
  ++ lib.optional (!withWayland) "DISABLE_WAYLAND=y"
  ++ lib.optional (!withX) "DISABLE_X=y";

  postPatch = ''
    substituteInPlace mk/linux.mk \
      --replace '-m644' '-Dm644' \
      --replace '-m755' '-Dm755' \
      --replace 'warpd.1.gz $(DESTDIR)' 'warpd.1.gz -t $(DESTDIR)' \
      --replace 'bin/warpd $(DESTDIR)' 'bin/warpd -t $(DESTDIR)'
  '';

  meta = {
    description = "Modal keyboard driven interface for mouse manipulation";
    homepage = "https://github.com/rvaiya/warpd";
    changelog = "https://github.com/rvaiya/warpd/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ hhydraa ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "warpd";
  };
})
