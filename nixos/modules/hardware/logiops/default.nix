{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.logiops;
  renderedConfig = (pkgs.formats.libconfig { }).generate "logid.cfg" cfg.settings;
in
{
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
      example = {
        devices = [{
          name = "Wireless Mouse MX Master 3";

          smartshift = {
            on = true;
            threshold = 20;
          };

          hiresscroll = {
            hires = true;
            invert = false;
            target = false;
          };

          dpi = 1500;

          buttons = [
            {
              cid = "0x53";
              action = {
                type = "Keypress";
                keys = [ "KEY_FORWARD" ];
              };
            }
            {
              cid = "0x56";
              action = {
                type = "Keypress";
                keys = [ "KEY_BACK" ];
              };
            }
          ];
        }];
      };
      description = ''
        Logid configuration. Refer to
        <link xlink:href="https://github.com/PixlOne/logiops/wiki/Configuration"/>
        for details on supported values;
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.logitech-udev-rules ];
    environment.etc."logid.cfg".source = renderedConfig;

    systemd.packages = [ cfg.package ];
    systemd.services.logid = {
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ renderedConfig ];
    };
  };

  meta.maintainers = with maintainers; [ ckie ];
}
