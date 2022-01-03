VUR
# Void User Repository
Renamed from nvoid

[![Check PR](https://github.com/oSoWoSo/VUR/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/oSoWoSo/VUR/actions/workflows/build.yml)

nvoid is a custom xbps-src repo which includes packages which can not be accepted into [void-packages](https://github.com/void-linux/void-packages/) or just experimental and WIP.

## supported architectures
all packages support `x86_64` (glibc), most of them support `x86_64-musl`. others has not tested yet.

## quick start

fetch void-packages tree first
```
git clone --depth 1 https://github.com/void-linux/void-packages
```
fetch VUR as well
```
git clone --depth 1 https://github.com/vb-linux/VUR
```
merge them
```
cp -r VUR/srcpkgs/*  void-packages/srcpkgs
cat VUR/custom-shlibs >> void-packages/etc/shlibs
```
install `xtools` and `base-devel`
```
xbps-install base-devel xtools
```
build `pkgname` and install it
```
cd void-packages
./xbps-src pkg <pkgname>
xi <pkgname>
```

