{ user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
      "com.apple.trackpad.scaling" = 3.0; # maximum tracking speed
    };
    dock = {
      autohide = true;
      magnification = true;
      largesize = 128;
    };
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    finder.ShowExternalHardDrivesOnDesktop = false;
    finder.ShowRemovableMediaOnDesktop = false;
    finder.ShowMountedServersOnDesktop = false;
    trackpad.Clicking = true;              # tap to click
    CustomUserPreferences = {
      # Keep three-finger dragging selected for built-in and Bluetooth trackpads.
      "com.apple.AppleMultitouchTrackpad" = {
        Dragging = false;
        TrackpadThreeFingerDrag = true;
      };
      "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
        Dragging = false;
        TrackpadThreeFingerDrag = true;
      };
      "com.apple.dock"."wvous-br-modifier" = 1048576; # Command key
    };
    dock.wvous-br-corner = 13;             # lock screen (bottom right)
  };
  nix-homebrew = {
    enable = true;
    inherit user;
    autoMigrate = true;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    caskArgs.appdir = "~/Applications";
    brews = [
      "herdr"
    ];
    casks = [
      "visual-studio-code"
      "handy"
      "alfred"
      "raycast"
      "dash"
      "obsidian"
      "google-chrome"
      "snipaste"
      "wezterm"
      "claude-code"
    ];
  };
}
