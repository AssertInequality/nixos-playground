{ config, pkgs, ... }:

{

    home-manager.users.user = { pkgs, ... }: {

## General Info required by home-manager

        home.stateVersion = "22.11";

## Environment Variables
        home.sessionVariables = {
            EDITOR = "nvim";
        };

## User-specific programs

        home.packages = with pkgs; [
            htop
                cifs-utils
                tree
                bat
                lsd
                gcc
                ripgrep
                rustup
                luajitPackages.luarocks-nix
                fd
                neovim
        ];

## Program-specific configs

#programs.home-manager.enable = true;

        programs.fish = {
            enable = true;
            shellAliases = {
                "v" = "nvim";
                "cl" = "clear";
                "ls" = "lsd --color always";
                "la" = "lsd -A --color always";
                "ll" = "lsd -lAh --color always";
            };
            shellInit = ''
                set fish_greeting
                '';
        };

        programs.starship = {
            enable = true;
        };

        programs.tmux = {
            enable = true;
            keyMode = "vi";
            customPaneNavigationAndResize = true;
            historyLimit = 20000;
            shortcut = "a";
            terminal = "screen-256color";
            shell = "/home/user/.nix-profile/bin/fish";
            escapeTime = 300;
            extraConfig = ''
                unbind %
                unbind '"'
                unbind m
                set -g mouse on
                bind | split-window -h
                bind - split-window -v
                bind -r m resize-pane -Z
                set-option -g status-position top
                set-option -sa terminal-overrides ',xterm-256color:RGB'
                '';
            plugins = with pkgs.tmuxPlugins; [
                vim-tmux-navigator
                    nord
                    cpu
            ];
        };

        programs.git = {
            enable = true;
            userName = "username";
            userEmail = "email";
            extraConfig = {
                init = { defaultBranch = "main"; };
                color = { ui = "auto"; };
            };
        };

## Services

# SSH Config
        programs.ssh.enable = true;
        programs.ssh.matchBlocks = {
            "user.github" = {
                hostname = "github.com";
                user = "git";
                identitiesOnly = true;
                identityFile = "${config.users.users.user.home}/.ssh/github_identity";
            };
        };

        services.gpg-agent = {
            enable = true;
            defaultCacheTtl = 1800;
            enableSshSupport = true;
        };

        services.syncthing.enable = true;
        services.syncthing.extraOptions = [ "--gui-address=0.0.0.0:8384" ];

    };
}
