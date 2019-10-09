#!/bin/sh
X86_64_URL=$(curl -I 'https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64' | grep -i '^Location:' | cut -c 11- | tr -d '[:space:]')
I386_URL=$(curl -I 'https://www.zotero.org/download/client/dl?channel=release&platform=linux-i686' | grep -i '^Location:' | cut -c 11- | tr -d '[:space:]')

X86_64_SHA512=$(curl "$X86_64_URL" | sha512sum | cut -c -128)
I386_SHA512=$(curl "$I386_URL" | sha512sum | cut -c -128)

GITHUB_TAG=$(curl "$(curl https://api.github.com/repos/zotero/zotero/git/refs/tags | jq -r '.[-1].object.url')")
VERSION=$(echo $GITHUB_TAG | jq -r '.tag')
DATE=$(echo $GITHUB_TAG | jq -r '.tagger.date' | cut -c -10)

cat > flathub.json <<"EOF"
{
    "only-arches": ["x86_64", "i386"]
}
EOF

cat > org.zotero.Zotero.json <<EOF
{
  "id": "org.zotero.Zotero",
  "runtime": "org.freedesktop.Platform",
  "runtime-version": "19.08",
  "sdk": "org.freedesktop.Sdk",
  "command": "zotero",
  "rename-desktop-file": "zotero.desktop",
  "rename-icon": "zotero",
  "finish-args": [
    "--socket=x11",
    "--share=ipc",
    "--share=network",
    "--filesystem=home"
  ],
  "modules": [
    "shared-modules/dbus-glib/dbus-glib-0.110.json",
    {
      "name": "zotero",
      "buildsystem": "simple",
      "sources": [
        {
          "type": "archive",
          "url": "$X86_64_URL",
          "sha512": "$X86_64_SHA512",
          "only-arches": [
            "x86_64"
          ]
        },
        {
          "type": "archive",
          "url": "$I386_URL",
          "sha512": "$I386_SHA512",
          "only-arches": [
            "i386"
          ]
        },
        {
          "type": "file",
          "path": "org.zotero.Zotero.appdata.xml"
        }
      ],
      "build-commands": [
        "mkdir -p /app/{bin,share}",
        "cp -R . /app/share/zotero",
        "install -D chrome/icons/default/default16.png /app/share/icons/hicolor/16x16/apps/zotero.png",
        "install -D chrome/icons/default/default32.png /app/share/icons/hicolor/32x32/apps/zotero.png",
        "install -D chrome/icons/default/default48.png /app/share/icons/hicolor/48x48/apps/zotero.png",
        "install -D chrome/icons/default/default256.png /app/share/icons/hicolor/256x256/apps/zotero.png",
        "desktop-file-install --dir=/app/share/applications --set-key=Exec --set-value=zotero --set-key=Icon --set-value=org.zotero.Zotero zotero.desktop",
        "install -D org.zotero.Zotero.appdata.xml /app/share/appdata/org.zotero.Zotero.appdata.xml",
        "ln -s /app/share/zotero/zotero /app/bin/zotero"
      ]
    }
  ]
}
EOF

cat > org.zotero.Zotero.appdata.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright [2006] [Corporation for Digital Scholarship] -->
<component type="desktop-application">
  <id>org.zotero.Zotero.desktop</id>
  <metadata_license>CC0-1.0</metadata_license>
  <project_license>AGPL-3.0</project_license>
  <name>Zotero</name>
  <summary>Collect, organize, cite, and share research</summary>
  <description>
    <p>
      Zotero [zoh-TAIR-oh] is a free, easy-to-use tool to help you collect,
      organize, cite, and share your research sources.
    </p>
    <p>
      [NOTE] If your Zotero folder is not located in the default location (~/Zotero)
      and is outside your home directory, please grant the permission to access
      that folder by the flatpak-override command (usage: "flatpak override --user
      --filesystem=/PATH/TO/ZOTEROFOLDER org.zotero.Zotero").
    </p>
  </description>
  <categories>
    <category>Office</category>
  </categories>
  <url type="homepage">https://www.zotero.org/</url>
  <launchable type="desktop-id">org.zotero.Zotero.desktop</launchable>
  <update_contact>guillaumepoiriermorency@gmail.com</update_contact>
  <releases>
    <release date="$DATE" version="$VERSION"/>
  </releases>
  <icon type="remote" height="64" width="64">https://www.zotero.org/static/images/icons/zotero-icon-64-70.png</icon>
  <icon type="remote" height="128" width="128">https://www.zotero.org/static/images/icons/zotero-icon-128-140.png</icon>
  <icon type="remote" height="256" width="256">https://www.zotero.org/static/images/icons/zotero-icon-128-140%402x.png</icon>
  <screenshots>
    <screenshot type="default">
      <image>https://raw.githubusercontent.com/flathub/org.zotero.Zotero/master/screenshots/screenshot-1.png</image>
      <caption>Zotero screenshot</caption>
    </screenshot>
  </screenshots>
  <content_rating type="oars-1.1">
    <content_attribute id="violence-cartoon">none</content_attribute>
    <content_attribute id="violence-fantasy">none</content_attribute>
    <content_attribute id="violence-realistic">none</content_attribute>
    <content_attribute id="violence-bloodshed">none</content_attribute>
    <content_attribute id="violence-sexual">none</content_attribute>
    <content_attribute id="violence-desecration">none</content_attribute>
    <content_attribute id="violence-slavery">none</content_attribute>
    <content_attribute id="violence-worship">none</content_attribute>
    <content_attribute id="drugs-alcohol">none</content_attribute>
    <content_attribute id="drugs-narcotics">none</content_attribute>
    <content_attribute id="drugs-tobacco">none</content_attribute>
    <content_attribute id="sex-nudity">none</content_attribute>
    <content_attribute id="sex-themes">none</content_attribute>
    <content_attribute id="sex-homosexuality">none</content_attribute>
    <content_attribute id="sex-prostitution">none</content_attribute>
    <content_attribute id="sex-adultery">none</content_attribute>
    <content_attribute id="sex-appearance">none</content_attribute>
    <content_attribute id="language-profanity">none</content_attribute>
    <content_attribute id="language-humor">none</content_attribute>
    <content_attribute id="language-discrimination">none</content_attribute>
    <content_attribute id="social-chat">none</content_attribute>
    <content_attribute id="social-info">none</content_attribute>
    <content_attribute id="social-audio">none</content_attribute>
    <content_attribute id="social-location">none</content_attribute>
    <content_attribute id="social-contacts">none</content_attribute>
    <content_attribute id="money-purchasing">none</content_attribute>
    <content_attribute id="money-gambling">none</content_attribute>
  </content_rating>
  <provides>
    <id>org.zotero.Zotero</id>
  </provides>

  <developer_name>Center for History and New Media at George Mason University</developer_name>

  <url type="bugtracker">https://www.zotero.org/support/dev/source_code</url>

  <url type="donation">https://www.zotero.org/getinvolved</url>

  <url type="help">https://www.zotero.org/support/</url>

  <url type="translate">https://www.zotero.org/support/dev/localization</url>
</component>
EOF
