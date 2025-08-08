# nix-darwin on Apple Silicon (aarch64-darwin)

An opinionated, minimal nix-darwin setup you can copy. It’s clean, flake-based, and safe to publish.

Highlights
- Flake-powered (nix-command and flakes enabled)
- aarch64-darwin host platform
- System defaults for Dock, Finder, Trackpad, NSGlobalDomain
- Nix maintenance: GC and store optimization on a schedule
- Clean module layout: apps, system, nix-core, users, optional remote builder
- Public-safe: remote builder disabled by default and kept out of Git

Quick start
1) Prereqs
   - Install Nix (multi-user recommended).
   - Install nix-darwin: https://nix-darwin.github.io/nix-darwin/manual/

2) Build (dry run)
   - darwin-rebuild build --flake .#watson-computer

3) Apply (switch)
   - sudo darwin-rebuild switch --flake .#watson-computer

Customize
- Username and machine
  - localUsername is set in flake.nix and passed to modules.
  - Hostname and timezone live in modules/system.nix.

- Apps and packages
  - Add or remove packages in modules/apps.nix (environment.systemPackages).

Remote builder (optional)
- This repo is public-safe: the remote builder module is disabled by default and ignored in Git.
- To enable locally:
  - Copy the example to a private file:
    - cp modules/remote-builder.example.nix modules/remote-builder.nix
  - Edit flake.nix specialArgs and set:
    - enableRemoteBuilder = true
    - remoteBuilderString = "user@host aarch64-linux /Users/you/.ssh/id_nix 1 1"
  - Switch:
    - sudo darwin-rebuild switch --flake .#watson-computer

Notes on caches
- nixConfig in flake.nix includes nix-community cache for pre-eval substituters.
- These keys are public cache keys and safe to commit.

Why this layout
- Simple files per concern
- Parameterized username so defaults and scripts don’t hardcode it
- Activation script narrows to Dock/Finder refresh instead of broad system calls

Issues or ideas
- PRs welcome! Feel free to fork and adapt. If you find better defaults or want Home Manager integrated, open an issue.

