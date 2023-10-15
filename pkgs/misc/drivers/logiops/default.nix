{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, udev
, libevdev
, libconfig
, glib
}:

stdenv.mkDerivation (oldAttrs: {
  pname = "logiops";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "pixlone";
    repo = "logiops";
    rev = "v${oldAttrs.version}";
    sha256 = "sha256-9nFTud5szQN8jpG0e/Bkp+I9ELldfo66SdfVCUTuekg=";
    # As of 2023-10-16, this is for `src/ipcgull`, a library also
    # maintained by the author and pinned to a specific commit.
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DLOGIOPS_VERSION=${oldAttrs.version}"
    "-DDBUS_SYSTEM_POLICY_INSTALL_DIR=${placeholder "out"}/share/dbus-1/system.d"
  ];
  patches = [ ./0001-Make-DBUS_SYSTEM_POLICY_INSTALL_DIR-externally-overr.patch ];
  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ udev libevdev libconfig glib ];

  postInstall = ''
    # Remove when upstream fixes their reload mechanism (added on v0.2.3)
    sed -ie '/^ExecReload/d' $out/lib/systemd/system/logid.service
  '';

  meta = with lib; {
    description = "Unofficial userspace driver for HID++ Logitech devices";
    homepage = "https://github.com/PixlOne/logiops";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ckie ];
    platforms = with platforms; linux;
  };
})
