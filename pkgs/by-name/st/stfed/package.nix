{ lib, rustPlatform, fetchFromGitHub, nix-update-script, pkg-config, }:

rustPlatform.buildRustPackage rec {
  pname = "stfed";
  version = "unstable-2023-11-01";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "stfed";
    rev = "e533aa4ae55b5c034d56d4aca2a063ad7b357623";
    hash = "sha256-cH/qQMAMpX9+DyPTTXa4I/vpVtGCSwqJBaC6it7ZI/g=";
  };

  cargoHash = "sha256-4rc8RXAwLGIzSy+yL/303gk4ifyZBhJqGRl1846+w38=";

  nativeBuildInputs = [ pkg-config ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description =
      "Syncthing Folder Event Daemon";
    license = licenses.gpl3Only; # unknown
    maintainers = with maintainers; [ ];
    mainProgram = "jk";
  };
}
