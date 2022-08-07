{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lighttpd.cgit;
  pathPrefix = if stringLength cfg.subdir == 0 then "" else "/" + cfg.subdir;
  configFile = pkgs.writeText "cgitrc"
    ''
      # default paths to static assets
      css=${pathPrefix}/cgit.css
      logo=${pathPrefix}/cgit.png
      favicon=${pathPrefix}/favicon.ico

      # user configuration
      ${cfg.configText}
    '';
in
{

  options.services.lighttpd.cgit = {

    enable = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc ''
        If true, enable cgit (fast web interface for git repositories) as a
        sub-service in lighttpd.
      '';
    };

    subdir = mkOption {
      default = "cgit";
      example = "";
      type = types.str;
      description = lib.mdDoc ''
        The subdirectory in which to serve cgit. The web application will be
        accessible at http://yourserver/''${subdir}
      '';
    };

    configText = mkOption {
      default = "";
      example = literalExpression ''
        '''
          source-filter=''${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py
          about-filter=''${pkgs.cgit}/lib/cgit/filters/about-formatting.sh
          cache-size=1000
          scan-path=/srv/git
        '''
      '';
      type = types.lines;
      description = lib.mdDoc ''
        Verbatim contents of the cgit runtime configuration file. Documentation
        (with cgitrc example file) is available in "man cgitrc". Or online:
        http://git.zx2c4.com/cgit/tree/cgitrc.5.txt
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cgit;
      defaultText = literalExpression "pkgs.cgit";
      description = "cgit derivation to use";
    };
  };

  config = mkIf cfg.enable {

    # make the cgitrc manpage available
    environment.systemPackages = [ cfg.package ];

    # declare module dependencies
    services.lighttpd.enableModules = [ "mod_cgi" "mod_alias" "mod_setenv" ];

    services.lighttpd.extraConfig = ''
      $HTTP["url"] =~ "^/${cfg.subdir}" {
          cgi.assign = (
              "cgit.cgi" => "${cfg.package}/cgit/cgit.cgi"
          )
          alias.url = (
              "${pathPrefix}/cgit.css" => "${cfg.package}/cgit/cgit.css",
              "${pathPrefix}/cgit.png" => "${cfg.package}/cgit/cgit.png",
              "${pathPrefix}"          => "${cfg.package}/cgit/cgit.cgi"
          )
          setenv.add-environment = (
              "CGIT_CONFIG" => "${configFile}"
          )
      }
    '';

    systemd.services.lighttpd.preStart = ''
      mkdir -p /var/cache/cgit
      chown lighttpd:lighttpd /var/cache/cgit
    '';

  };

}
