# Building #
```
flatpak-builder --force-clean --install-deps-from=flathub --repo=repo build com.github.tesseract-ocr.json
```

# Bundle #
```
flatpak build-bundle repo tesseract-4.0.0.flatpak com.github.tesseract-ocr 4.0.0
```

# Installing #
```
flatpak install --assumeyes --user tesseract-4.0.0.flatpak
```


