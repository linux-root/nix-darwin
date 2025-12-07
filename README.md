# Multi-platform Nix Configuration

Flake-based configuration for macOS (nix-darwin), NixOS, and standalone home-manager on Linux.

## Platforms

**macOS (nix-darwin + home-manager)**
```sh
sudo darwin-rebuild switch --flake .#watson-computer
```

**Ubuntu/Linux (standalone home-manager)**
```sh
home-manager switch --flake .#w47s0n@ubuntu      # x86_64
home-manager switch --flake .#w47s0n@ubuntu-arm  # aarch64
```

## Structure

```
darwin/          # macOS system modules (apps, system, nix-core, users)
home/            # home-manager configs (common, darwin, linux)
nixos/           # NixOS configuration (template)
flake.nix        # Entry point with all configurations
```

## Customization

- Usernames: `macosUsername` and `linuxUsername` in `flake.nix`
- Packages: `darwin/apps.nix` (system) or `home/*.nix` (user)
- macOS defaults: `darwin/system.nix`

## Remote Builder (optional)

Disabled by default. To enable:
```sh
cp darwin/remote-builder.example.nix darwin/remote-builder.nix
# Edit flake.nix: enableRemoteBuilder = true
```

