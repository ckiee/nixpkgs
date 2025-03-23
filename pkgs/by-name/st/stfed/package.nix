{ lib, rustPlatform, fetchFromGitHub, nix-update-script, pkg-config, }:

rustPlatform.buildRustPackage rec {
  pname = "stfed";
  version = "unstable-2025-01-19";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "stfed";
    rev = "39512c6b8f3ff3b402f95efafbb1c8819919fc84";
    hash = "sha256-N2FTjpw0KJj8t6BMznW9gx7OJxYV6Gn3FBGd+g6nr70=";
  };

  cargoHash = "sha256-8ZZzRbnX11pzAr/o/GbwjdwRS7yXVVglZ8oFb4DXc3g=";

  nativeBuildInputs = [ pkg-config ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description =
      "Syncthing Folder Event Daemon";
    license = licenses.gpl3Only; # unknown
    maintainers = with maintainers; [ ];
    mainProgram = "stfed";
  };
}
