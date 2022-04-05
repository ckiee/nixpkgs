{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.logiops;
in {
  meta.maintainers = with maintainers; [ ckie ];

  options.services.logiops = {
    enable = mkEnableOption "Logiops HID++ configuration";

    package = mkOption {
      type = types.package;
      default = pkgs.logiops;
      defaultText = literalExpression "pkgs.logiops";
      description = "The package to use for logiops";
    };

    settings = mkOption {
      inherit (pkgs.formats.libconfig { }) type;
      default = { };
      description = ''
        Logid configuration. Refer to
        <link xlink:href="https://github.com/PixlOne/logiops/wiki/Configuration"/>
        for details on supported values;
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.logitech-udev-rules ];
    environment.etc."logid.cfg".source =
      (pkgs.formats.libconfig { }).generate "logid.cfg" cfg.settings;

    systemd.packages = [ cfg.package ];
    systemd.services.logid.wantedBy = [ "multi-user.target" ];
  };
}
