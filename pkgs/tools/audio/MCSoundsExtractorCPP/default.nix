{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "MCSoundsExtractorCPP";
  version = "unstable-2021-05-12";

  src = fetchFromGitHub {
    owner = "Ravbug";
    repo = "MCSoundsExtractorCPP";
    rev = "03e35885f4db12c5c2932d92a6a024edbc3ed487";
    sha256 = "sha256-JABMvXYVsRP8NPV8JSYAQiS9QzXTFYrZ9/Yq2xLWg54=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook ];
  buildInputs = [ gtk3 ];

  # TODO: possibly replace vendored wxWidgets

  postInstall = ''
    mkdir -p $out/bin
    # TODO: fix upstream's cmakelists.txt
    cp -v /build/source/build/Release/MCSoundsExtractor $out/bin
  '';

  meta = with lib; {
    description = "Extracts the audio files out of Minecraft Java Edition";
    homepage = "https://github.com/Ravbug/MCSoundsExtractorCPP";
    license = licenses.unfreeRedistributable; # GPL 3.0 with Commons Clause v1.0
    maintainers = with maintainers; [ ckie ];
    platforms = with platforms; linux; # upstream also supports darwin
  };
}
