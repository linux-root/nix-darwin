{ lib, localUsername, remoteBuilderString ? null, enableRemoteBuilder ? false, ... }:
# Example remote builder configuration. Copy this file to:
#   modules/remote-builder.nix
# and set enableRemoteBuilder = true with a real remoteBuilderString.
# Format: "${sshUser}@${host} ${platform} ${sshKeyPath} ${maxJobs} ${speedFactor}"
# Example:
# remoteBuilderString = "nix@buildbox aarch64-linux /Users/you/.ssh/id_nix 1 1";
{
  nix.settings = lib.mkIf (enableRemoteBuilder && remoteBuilderString != null && remoteBuilderString != "") {
    builders = lib.mkForce [ remoteBuilderString ];
    trusted-users = lib.mkForce [ "root" localUsername ];
  };
}

