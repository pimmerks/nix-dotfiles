# Wallpapers

## Split wallpapers 
```shell
nix-shell -p imagemagick --command "convert -crop 100%x50% ./originals/<file> <file>_%d.jpg/png"
```
