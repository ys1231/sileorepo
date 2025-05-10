#!/bin/bash
script_full_path=$(dirname "$0")
cd $script_full_path || exit 1

rm Packages Packages.bz2 Packages.xz Packages.zst Release Release.gpg

echo "[Repository] Generating Packages..."
apt-ftparchive packages ./pool > Packages
zstd -q -c19 Packages > Packages.zst
xz -c9 Packages > Packages.xz
bzip2 -c9 Packages > Packages.bz2

echo "[Repository] Generating Release..."
apt-ftparchive \
		-o APT::FTPArchive::Release::Origin="Iyue" \
		-o APT::FTPArchive::Release::Label="Iyue" \
		-o APT::FTPArchive::Release::Suite="stable" \
		-o APT::FTPArchive::Release::Version="1.0" \
		-o APT::FTPArchive::Release::Codename="ios" \
		-o APT::FTPArchive::Release::Architectures="iphoneos-arm iphoneos-arm64" \
		-o APT::FTPArchive::Release::Components="main" \
		-o APT::FTPArchive::Release::Description="Iyue for sileo Repo" \
		release . > Release

echo "[Repository] Signing Release using Amy's GPG Key..."
if gpg -abs -u 767D46A4709E4297AEDD4F0783BBBE5ADBD940CB -o Release.gpg Release 2>/dev/null; then
    echo "[Repository] Release signed successfully."
else
    echo "[Repository] Warning: GPG signing failed. No secret key found. Continuing without signature."
    # 创建一个空的Release.gpg文件作为占位符
    touch Release.gpg
fi

echo "[Repository] Finished"
