# =============================================================================
#  git.nix — global git config (basic, user will tune)
# =============================================================================
{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;

    userName  = "Ben Maurer";
    userEmail = "benzooku@gmail.com";

    # Default branch for `git init`
    init.defaultBranch = "main";

    # Pull behaviour
    extraConfig = {
      pull = {
        rebase = true;
        ff = "only";
      };

      push = {
        autoSetupRemote = true;
        default = "simple";
      };

      # Useful defaults
      core = {
        editor = "nvim";
        pager = "delta";
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        autocrlf = "input";
        attributesfile = "~/.config/git/attributes";
      };

      # Diffs / merges
      diff = {
        algorithm = "histogram";
        mnemonicPrefix = true;
        colorMoved = "default";
      };
      merge.conflictStyle = "zdiff3";
      rerere.enabled = true;

      # Better log
      log.date = "iso-strict";
      log.graph = "decorate,oneline,short";
      log.showSignature = true;

      # Status
      status = {
        branch = true;
        short = true;
      };

      # Aliases
      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "!gitk";
        lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      };

      # GitHub
      github.user = "benzooku";

      # Credential helper (cache for 1h)
      credential.helper = "cache --timeout=3600";

      # Signing key (set when you have one)
      # user.signingkey = "";
      # commit.gpgsign = true;
    };
  };

  # ── gh CLI ──────────────────────────────────────────────────────────────
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "nvim";
      aliases = {
        co = "pr checkout";
        rv = "pr review";
      };
    };
    # Auth lives in ~/.config/gh/hosts.yml — set up with `gh auth login`
  };
}