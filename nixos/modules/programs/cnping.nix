{ config, lib, pkgs, ... }:

let
  cfg = config.programs.cnping;
in
{
  options = {
    programs.cnping = {
      enable = lib.mkEnableOption "a setcap wrapper for cnping";
      package = lib.mkOption {
        default = pkgs.cnping;
        type = lib.types.package;
        defaultText = lib.literalExpression "pkgs.cnping";
        description = "cnping derivation to use";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.cnping = {
      owner = "root";
      group = "root";
      source = "${cfg.package}/bin/cnping";
      capabilities = "cap_net_raw+ep";
    };
  };
}
