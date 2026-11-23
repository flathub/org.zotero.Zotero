# org.zotero.Zotero

Flatpak manifest for [Zotero](https://github.com/zotero/zotero).

Not verified by, affiliated with, or supported by the Zotero project. Please confirm that problems are reproducible using the [official binary builds](https://www.zotero.org/download/) before reporting a bug in the Zotero Forums.

## Known bugs

### Automatic installation of LibreOffice extension fails

Due to sandboxing, Zotero can't access the system-wide LibreOffice installation. However, the extension can be installed manually using LibreOffice's Extension Manager. The extension bundled with Zotero is located in the following directory:
`/var/lib/flatpak/app/org.zotero.Zotero/current/active/files/share/zotero/integration/libreoffice/`

#### Manual installation

1. In LibreOffice, go to **Tools → Extensions**.
2. Click **Add** and navigate to the directory specified above.
3. Select the `Zotero_LibreOffice_Integration.oxt` file and click **Open**.
4. Restart LibreOffice when prompted to complete the installation.

## Remove home access permission

1. if they already exist, move folders `~/.zotero` and `~/Zotero` to the app sandbox, typically in `~/.var/app/org.zotero.Zotero/`
2. remove home access premission: `flatpak override --user --nofilesystem=home org.zotero.Zotero`

### Limitations
Drag-and-drop functionality might stop working if you remove home directory permissions using the command above.
In that case, you can use the 'Add Attachment' button and manually select the files to achieve the same effect.
Alternatively, you may give zotero access to only the directories you want to drag-and-drop from, while keeping the rest of
your home directory locked away. For example, if want to give read access to your downloads directory, you can use
"flatpak override --user --filesystem=~/Downloads:ro org.zotero.Zotero".

Please also read issue [82](https://github.com/flathub/org.zotero.Zotero/issues/82).

## Give access to system keyring

By default, access to `org.freedesktop.secrets` is prohibited to prevent Zotero from accessing the whole keyring. Because of this,
Zotero will store the credentials unencrypted. To change this, run
`flatpak override --user --talk-name org.freedesktop.secrets org.zotero.Zotero`.

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
