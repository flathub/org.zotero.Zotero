# org.zotero.Zotero

Flatpak manifest for [Zotero](https://github.com/zotero/zotero).

Not verified by, affiliated with, or supported by the Zotero project. Please confirm that problems are reproducible using the [official binary builds](https://www.zotero.org/download/) before reporting a bug in the Zotero Forums.

## Known bugs

### Word processor plugins crash Zotero on Wayland

See issue [165](https://github.com/flathub/org.zotero.Zotero/issues/165).

Workaround: Run the flatpak in X11/xwayland (`flatpak override --user --nosocket=wayland --socket=x11 org.zotero.Zotero`).

## Notes

### Remove home access permission

1. if they already exist, move folders `~/.zotero` and `~/Zotero` to the app sandbox, typically in `~/.var/app/org.zotero.Zotero/`
2. remove home access premission: `flatpak override --user --nofilesystem=home org.zotero.Zotero`

Please read issue [82](https://github.com/flathub/org.zotero.Zotero/issues/82) if you're curious why Zotero still uses the home permission by default.

## Development

### Build locally

```sh
flatpak-builder --user --force-clean --install build org.zotero.Zotero.yaml
```

### Update the beta branch

[flatpak-external-data-checker](https://github.com/flathub-infra/flatpak-external-data-checker) is currently not enabled for branch `beta`.

To update, run the following commands:

```sh
git switch beta
flatpak run org.flathub.flatpak-external-data-checker --commit-only org.zotero.Zotero.yaml
git push
```

And open a PR against `beta`.
