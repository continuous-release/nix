# nix

Nix build-system testbed for
[continuous-release](https://github.com/continuous-release).

Every push to `main` cuts a release. CI rewrites `version.txt` with the version
computed from conventional commits, runs `nix flake check`, builds with
`nix build`, and attaches the resulting tarball to the GitHub Release.

The version is injected as `RELEASE_VERSION` at build time, so the binary
reports the released version while the flake itself stays version-agnostic.

## Local

```bash
nix flake check
nix build .#default
./result/bin/continuous-release-nix
```

To reproduce a release build:

```bash
echo 1.2.3 > version.txt
git add -f version.txt
nix build .#default
./result/bin/continuous-release-nix   # continuous-release-nix 1.2.3
```

## Layout

| Path          | Purpose                                      |
| ------------- | -------------------------------------------- |
| `flake.nix`   | Package, check, and app outputs              |
| `version.txt` | Release version, rewritten by CI             |
| `src/main.rs` | Prints the build-time version                |
| `Cargo.toml`  | Rust package metadata                        |

## Contract

See [continuous-release/.github](https://github.com/continuous-release/.github)
for the shared workflow, version rules, and release notes format.
