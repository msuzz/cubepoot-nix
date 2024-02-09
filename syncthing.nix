{
  services = {
    syncthing = {
      enable = true;
      user = "michael";
      dataDir = "/home/michael/Sync";
      configDir = "/home/michael/.config/syncthing";
      overrideDevices = false;     # overrides any devices added or deleted through the WebUI
      overrideFolders = false;     # overrides any folders added or deleted through the WebUI
    };
  };
}
