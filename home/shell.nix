# =============================================================================
#  shell.nix — zsh as default, starship, env vars, aliases
# =============================================================================
{ config, pkgs, lib, ... }:

{
  # ── zsh — the default interactive shell ──────────────────────────────────
  programs.zsh = {
    enable = true;
    setDefault = true;

    # dot-prefixed dotfiles live under xdg.configHome/zsh (HM-managed)
    dotDir = ".config/zsh";

    # Init content (sourced into .zshrc)
    initExtra = ''
      # ── Editor / pager ────────────────────────────────────────────────
      export EDITOR="nvim"
      export VISUAL="nvim"
      export PAGER="bat --style=plain --paging=always"
      export MANPAGER="bat --style=plain --paging=always"
      export LESS="-FRX"

      # ── Modern CLI replacements ──────────────────────────────────────
      alias ls='eza --icons --group-directories-first'
      alias ll='eza -la --icons --group-directories-first --git'
      alias lt='eza --tree --level=3 --icons'
      alias cat='bat --style=plain'
      alias grep='rg'
      alias find='fd'
      alias vim='nvim'
      alias v='nvim'

      # ── Convenience ───────────────────────────────────────────────────
      alias gs='git status'
      alias gp='git push'
      alias gpl='git pull'
      alias gc='git commit'
      alias gd='git diff'
      alias lg='lazygit'
      alias df='df -h'
      alias du='du -h'
      alias ps='ps -ef | head -50'
      alias reload='source ~/.zshrc'

      # ── Hyprland ───────────────────────────────────────────────────────
      alias hyprconf='$EDITOR ~/.config/hypr/hyprland.conf'
      alias hyprreload='hyprctl reload'
      alias hyprkill='hyprctl killactive'
      alias theme='$EDITOR ~/.config/hypr/hyprland.conf'

      # ── Pipewire / audio ──────────────────────────────────────────────
      alias vol='wpctl set-volume @DEFAULT_AUDIO_SINK@'
      alias mute='wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'

      # ── Nix ────────────────────────────────────────────────────────────
      alias nrs='sudo nixos-rebuild switch --flake ~/nixconfig#t480s'
      alias nrb='sudo nixos-rebuild build --flake ~/nixconfig#t480s'
      alias nfu='cd ~/nixconfig && nix flake update'
      alias nfc='cd ~/nixconfig && nix flake check --no-build --impure'
      alias nh='cd ~/nixconfig && nix run nixpkgs#nh'
      alias nhs='nh os switch --ask --hostname t480s'

      # ── Quick nav ──────────────────────────────────────────────────────
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      alias ~='cd ~'
      alias nixcfg='cd ~/nixconfig'

      # ── Starship prompt ────────────────────────────────────────────────
      eval "$(starship init zsh)"

      # ── zoxide (smarter cd) ────────────────────────────────────────────
      eval "$(zoxide init zsh --cmd cd)"

      # ── fzf defaults ───────────────────────────────────────────────────
      if [[ -f $(brew --prefix 2>/dev/null)/opt/fzf/shell/key-bindings.zsh ]]; then
        source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
      fi
      export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded --preview-window=right:60%"
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

      # ── direnv ─────────────────────────────────────────────────────────
      eval "$(direnv hook zsh)"

      # ── mise-less Python/Node: per-project via `nix develop` ────────────
      # If a project has a flake.nix or shell.nix, `nix develop` will drop
      # you into a shell with the right toolchain. We don't install asdf.

      # ── Misc ───────────────────────────────────────────────────────────
      export PATH="$HOME/.local/bin:$PATH"
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_CACHE_HOME="$HOME/.cache"
      export XDG_STATE_HOME="$HOME/.local/state"

      # ── Local override (not tracked) ───────────────────────────────────
      [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
    '';

    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -la --icons --group-directories-first --git";
      cat = "bat --style=plain";
      grep = "rg";
    };

    # Nix-managed zsh plugins (oh-my-zsh is NOT used — we keep it pure Nix)
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
    ];

    # History
    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.local/state/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };

    # Completion
    enableCompletion = true;
    completionInit = "autoload -U compinit && compinit";

    defaultKeymap = "emacs";
    enableGlobalCompInit = false;
  };

  # ── Starship prompt — fully managed by Home Manager ──────────────────────
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settingsFile = ./starship/starship.toml;
  };

  # ── tmux ────────────────────────────────────────────────────────────────
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;
    baseIndex = 1;
    viMode = false;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
      tmuxPlugins.yank
    ];
    extraConfig = ''
      # Matrix-flavored status bar
      set -g status-style 'bg=#0d140d,fg=#cfd4cf'
      set -g status-left-length 80
      set -g status-right-length 80
      set -g status-left '#[fg=#41cc66,bold] #S #[default]'
      set -g status-right '#[fg=#8a918c]%Y-%m-%d %H:%M '
      set -g window-status-current-style 'fg=#41cc66,bold'
      set -g pane-border-style 'fg=#1f2a1f'
      set -g pane-active-border-style 'fg=#41cc66'
    '';
    keyMode = "emacs";
  };

  # ── git-delta as default diff pager ──────────────────────────────────────
  programs.git.attributes = [
    "* diff=delta"
    "*.md diff=markdown"
  ];
  programs.git.delta = {
    enable = true;
    options = {
      navigate = true;
      light = false;
      decorations = {
        commit-decoration-style = "yellow bold ol";
        file-style = "magenta bold";
        file-decoration-style = "magenta";
        hunk-header-decoration-style = "cyan bold";
      };
      features = {
        line-numbers = true;
        side-by-side = true;
        keep-plus-minus-subjects = true;
      };
    };
  };
}