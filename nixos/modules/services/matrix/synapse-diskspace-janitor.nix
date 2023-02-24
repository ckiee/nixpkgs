{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.matrix-synapse-diskspace-janitor;

  format = pkgs.formats.json { };
  configFile = format.generate "synapse-diskspace-janitor-config.json" cfg.settings;
in
{
  meta.maintainers = with maintainers; [ ckie ];
  options.services.matrix-synapse-diskspace-janitor = {
    enable = mkEnableOption (lib.mdDoc "matrix-synapse-diskspace-janitor");
    package = mkOption {
      type = types.package;
      default = pkgs.matrix-synapse-tools.matrix-synapse-diskspace-janitor;
      defaultText = lib.literalExpression "pkgs.matrix-synapse-tools.matrix-synapse-diskspace-janitor";
      description = lib.mdDoc "matrix-synapse-diskspace-janitor package to use";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;
      };
      default = { };
      description = lib.mdDoc ''
        Generates the configuration file. Refer to
        <https://git.cyberia.club/cyberia/matrix-synapse-diskspace-janitor#configuration-overview>
        for details on supported values.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    systemd.services.matrix-synapse-diskspace-janitor = {
      description = "Matrix Synapse Disk Space Janitor";
      documentation = [ "https://git.cyberia.club/cyberia/matrix-synapse-diskspace-janitor" ];
      serviceConfig = {
        DynamicUser = true;
        User = "matrix-synapse-diskspace-janitor";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        StateDirectory = "matrix-synapse-diskspace-janitor";
        ExecStart = "${cfg.package}/bin/matrix-synapse-diskspace-janitor";
        Restart = "on-failure";
        RestartSec = 10;
        StartLimitBurst = 5;
      };
    };
  };
}
