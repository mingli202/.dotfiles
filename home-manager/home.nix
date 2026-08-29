{
  config,
  additionalPkgs,
  pkgs,
  ...
}:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  mkSymlink = filepath: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${filepath}";

  mkBin = name: text: pkgs.writeShellScriptBin name text;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "vincentliu";
  home.homeDirectory = "/Users/vincentliu";

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
      (mkBin "hms" "home-manager switch -b backup")

      (mkBin "ls" ''
        exec eza --group-directories-first -F --icons auto "$@"
      '')

      (mkBin "ll" ''
        exec eza -l --group-directories-first -F --icons -h --git "$@"
      '')

      (mkBin "lt" ''
        exec eza --tree --git-ignore "$@"
      '')

      (mkBin "l" ''
        exec ls "$@"
      '')

      (mkBin "v" ''
        exec nvim "$@"
      '')

      (mkBin "nv" ''
        exec neovide --frame buttonless "$@"
      '')

      (mkBin "t" ''
        exec tmux "$@"
      '')

      (mkBin "fz" ''
        exec fzf \
          --preview 'bat --color=always --style=numbers --line-range=:500 {}' \
          "$@"
      '')

      (mkBin "vf" ''
        exec nvim "$(fz)"
      '')

      (mkBin "nvf" ''
        exec neovide --frame none "$(fz)"
      '')

      (mkBin "lg" ''
        exec lazygit "$@"
      '')

      (mkBin "cl" ''
        exec clear "$@"
      '')

      (mkBin "ns" ''
        exec nix-shell --command zsh "$@"
      '')

      (mkBin "ncg" ''
        exec nix-collect-garbage "$@"
      '')

      (mkBin "ct" ''
        export TERM=screen-256color
        exec "$HOME/dev/Codes/C/ncurses/tetris/bin/tetris" "$@"
      '')

      (mkBin "pn" ''
        exec pnpm "$@"
      '')

      (mkBin "px" ''
        exec pnpx "$@"
      '')

      (mkBin "g" ''
        exec git "$@"
      '')

      (mkBin "gm" ''
        git add . && git commit -m "$@"
      '')

      (mkBin "gz" ''
        git add . && git cz "$@"
      '')

      (mkBin "gp" ''
        exec git push "$@"
      '')

      (mkBin "ttt" ''
        exec typing-test-tui "$@"
      '')

      (mkBin "tt" ''
        exec typing_test "$@"
      '')

      (mkBin "cc" ''
        exec codex --yolo "$@"
      '')

      (mkBin "oc" ''
        exec opencode "$@"
      '')

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
      nodejs-slim
      nodejs-slim.npm
      python314
      rustup

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #   autosuggestion.enable = true;
  #   syntaxHighlighting.enable = true;
  # };
}
