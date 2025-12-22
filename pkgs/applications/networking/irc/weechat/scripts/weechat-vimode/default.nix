{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "weechat-vimode";
  version = "git";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/GermainZ/weechat-vimode/57bd66cf558abc12e5b32a08064e58d5eaf713ce/vimode.py";
    sha256 = "sha256-YRFIcvTJcGjmcPWOPkTz3DB40fudVcZ1MiT36qi/hyI=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/vimode.py
  '';

  passthru = {
    scripts = [ "vimode.py" ];
  };

  meta = with lib; {
    description = "Add vi/vim-like modes and keybindings to WeeChat";
    homepage = "https://github.com/weechat/scripts/blob/master/python/vimode.py";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
