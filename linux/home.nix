{ config, lib, pkgs, ... }:

let
  user = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";
  dotfiles = "${homeDirectory}/.dotfiles";
in
{
  assertions = [
    {
      assertion = user != "" && homeDirectory != "";
      message = "Run Linux Home Manager through linux/bootstrap.sh or linux/rebuild.sh so USER and HOME are available.";
    }
  ];

  home.username = user;
  home.homeDirectory = homeDirectory;
  home.stateVersion = "26.05";
  home.backupFileExtension = "backup";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    jq
    lazygit
    neovim
    zsh-completions
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables.EDITOR = "nvim";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch = {
      enable = true;
      searchUpKey = [ "^[[A" "^[OA" ];
      searchDownKey = [ "^[[B" "^[OB" ];
    };
    setOptions = [ "AUTO_PUSHD" "PUSHD_IGNORE_DUPS" ];
    initContent = lib.mkOrder 600 ''
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
    plugins = [
      {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
    ];
    shellAliases = {
      ".." = "cd ..";
      gst = "git status";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # These are user-authored config files. Keep Herdr's runtime files local.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr/config.toml";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  home.file.".pi/agent/themes".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/themes";
  home.file.".pi/agent/extensions".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/extensions";
  home.file.".pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/models.json";
  home.file.".pi/agent/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
