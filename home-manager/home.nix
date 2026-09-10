{
  config,
  additionalPkgs,
  dotfilesDirectory,
  pkgs,
  lib,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  configDir = config.xdg.configHome;

  dotfiles = dotfilesDirectory;
  mkSymlink = filepath: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${filepath}";

  mkBin = name: text: pkgs.writeShellScriptBin name text;
  mkActivation = script: lib.hm.dag.entryAfter [ "writeBoundry" ] script;
in
{
  # Username and home directory are supplied by the flake for this machine.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      # # Adds the 'hello' command to your environment. It prints a friendly
      # # "Hello, world!" when run.
      # pkgs.hello

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
      (mkBin "hm" ''exec home-manager "$@"'')
      (mkBin "hms" ''home-manager switch -b backup "$@"'')

      # general tools
      cmake
      ffmpeg
      imagemagick
      gh
      git
      htop
      rsync
      tmux
      tokei
      pkg-config
      unzip

      zsh-autosuggestions
      zsh-syntax-highlighting
      zsh-vi-mode

      # better clis
      bat
      btop
      eza
      fd
      fzf
      lazygit
      ripgrep
      starship
      yazi
      zoxide

      # nvim
      neovim
      tree-sitter

      # package managers
      bun
      pnpm
      uv

      # languages
      go
      python314
      nodejs-slim
      nodejs-slim.npm

      cargo
      rustc
      clippy

      ocaml
      opam # ocaml package managers
      ocamlPackages.utop

      # lsp, lint, formatters
      biome
      ccls
      jq
      nixfmt

      # fun
      cbonsai
      cmatrix
      cowsay
      fastfetch
      fortune
      hello
      sl
    ]
    # Basic build tools are not necessarily present on a fresh Linux install.
    ++ lib.optionals pkgs.stdenv.isLinux [
      gnumake
      gcc
      gnutar
    ]
    ++ additionalPkgs pkgs;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".zshrc".source = mkSymlink ".zshrc";
    ".gitconfig".source = mkSymlink ".gitconfig";
    ".tmux.conf".source = mkSymlink ".tmux.conf";
    ".wezterm.lua".source = mkSymlink ".wezterm.lua";
    ".aerospace.toml".source = mkSymlink ".aerospace.toml";
    ".config/ghostty/config".source = mkSymlink "ghostty/config";
    ".config/kitty/kitty.conf".source = mkSymlink "kitty.conf";
    ".config/starship.toml".source = mkSymlink "starship.toml";

    ".config/zed/settings.json".source = mkSymlink "zed/settings.json";
    ".config/zed/keymap.json".source = mkSymlink "zed/keymap.json";
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/vincentliu/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.activation = {
    initNvimConfig = mkActivation ''
      if [[ ! -d "$HOME/.config/nvim" ]]; then
          verboseEcho "cloning nvim config"
          mkdir -p ${configDir}
          run ${pkgs.git}/bin/git clone https://github.com/mingli202/nvim_config.git ${configDir}/nvim
      fi
    '';

    initTpm = mkActivation ''
      if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
          verboseEcho "cloning tmux package manager"
          run mkdir -p ${homeDir}/.tmux/plugins
          run ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm ${homeDir}/.tmux/plugins/tpm
      fi
    '';

    initOpam = mkActivation ''
      if [ ! -f "$HOME/.opam/config" ]; then
        verboseEcho "Initializing opam..."
        run ${pkgs.opam}/bin/opam init --bare --yes
      fi
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
