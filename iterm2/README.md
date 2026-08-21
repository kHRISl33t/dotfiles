# iTerm2 profile

A portable, editable iTerm2 Dynamic Profile. It replaces the full preferences
backup so this repository does not contain machine paths, window state, bookmark
data, or installation identifiers.

## Files

| File | Purpose |
|---|---|
| `dotfiles.json` | The profile settings tracked in this repository |
| `install.sh` | Copies the profile into iTerm2's watched Dynamic Profiles folder |
| `tests/install-test.sh` | Checks the profile and installer in a temporary home directory |

## What is in it

The `Dotfiles` profile sets only the portable choices from the old plist:

- Hack Nerd Font Mono Bold 12 for ASCII and non-ASCII text
- 8% background transparency, blur enabled, and blur radius 19
- Visual bell enabled
- `xterm-256color`
- The login shell and current directory, with no custom command or fixed path

Everything else inherits from iTerm2's default profile. The root `Brewfile`
installs the required font with the `font-hack-nerd-font` cask.

## Install

From the repository root:

```bash
./iterm2/install.sh
```

iTerm2 watches `~/Library/Application Support/iTerm2/DynamicProfiles`, so the
profile appears as `Dotfiles` without importing a plist. In iTerm2 Settings,
select **Profiles > Dotfiles > Other Actions > Set as Default** once.

The installer is safe to re-run. If `dotfiles.json` already exists there with
different contents, it is moved to
`~/Library/Application Support/iTerm2/DynamicProfiles Backups` first. Backups
live outside the watched folder so iTerm2 does not load them as extra profiles.

## Edit

Edit `dotfiles.json`, then run `./iterm2/install.sh` again. Keep `Name` and
`Guid`; iTerm2 requires both, and a Dynamic Profile GUID must not match a regular
profile. All other keys are normal iTerm2 profile preference names.

The repository copy is the source of truth. Changes made in the iTerm2 UI are
not written back to it.

## Verify

```bash
./iterm2/tests/install-test.sh
```

The test installs into a temporary home directory. It does not touch the active
iTerm2 configuration.
