{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, glib
, gst_all_1
, gtk3
, clang
, libclang
}:

rustPlatform.buildRustPackage rec {
  pname = "ntsc-rs";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "valadaptive";
    repo = "ntsc-rs";
    rev = "v${version}";
    hash = "sha256-M0KlAZtS3t5ow7GQ6R1PXVVSxVUHZu8ADIXGIwYf/hg=";
    fetchSubmodules = true; # vendors openfx
  };

  nativeBuildInputs = [ pkg-config clang ];
  buildInputs = [
    glib
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk3
  ];

  env.LIBCLANG_PATH = "${libclang.lib}/lib";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "simdnoise-3.1.7" = "sha256-wIHglErPcNfWbxU5HOr4yqSDtREsjskkDCpi1B8yjaQ=";
    };
  };


  meta = with lib; {
    description = "Application and plugin (After Effects/OpenFX) for analog TV/VHS artifacts";
    homepage = src.homepage;
    license = licenses.unfree; # TODO..
    maintainers = with maintainers; [ ckie ];
  };
}
