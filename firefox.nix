{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    # On NixOS (without Home Manager), *all* settings are
    # managed via policies.
    policies = {

      # 1. Force-install Extensions
      "ExtensionSettings" = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        # Bitwarden
        "446900e4-71c2-419f-a6a7-df9c091e268b" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
        # h264ify
        "{f73df109-8fb4-453e-8373-f59e61ca4da3}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/h264ify/latest.xpi";
        };
      };

      # 2. Configure about:config settings
      # This replaces the 'profiles' block that was causing the error.
      "Preferences" = {
        "signon.rememberSignons" = {
          Value = false;
          Status = "locked";
        };
        "browser.translations.enable" = {
          Value = false;
          Status = "locked";
        };
        "browser.ml.enable" = {
          Value = false;
          Status = "locked";
        };
        "browser.tabs.groups.smart.enabled" = {
          Value = false;
          Status = "locked";
        };
        "browser.uidensity" = {
          Value = 1;
          Status = "locked";
        };
        "browser.cache.disk.enable" = {
          Value = false;
          Status = "locked";
        };
        "network.trr.mode" = {
          Value = 2;
          Status = "locked";
        };
        "network.trr.uri" = {
          Value = "https://mozilla.cloudflare-dns.com/dns-query";
          Status = "locked";
        };
      };
    };
  };
}
