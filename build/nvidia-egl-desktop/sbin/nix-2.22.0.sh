#!/bin/sh

# This script installs the Nix package manager on your system by
# downloading a binary distribution and running its installer script
# (which in turn creates and populates /nix).

{ # Prevent execution if this script was only partially downloaded
oops() {
    echo "$0:" "$@" >&2
    exit 1
}

umask 0022

tmpDir="$(mktemp -d -t nix-binary-tarball-unpack.XXXXXXXXXX || \
          oops "Can't create temporary directory for downloading the Nix binary tarball")"
cleanup() {
    rm -rf "$tmpDir"
}
trap cleanup EXIT INT QUIT TERM

require_util() {
    command -v "$1" > /dev/null 2>&1 ||
        oops "you do not have '$1' installed, which I need to $2"
}

case "$(uname -s).$(uname -m)" in
    Linux.x86_64)
        hash=fcbed56d4b01189696fcb70afb52708b95cd6b2e6094a5df44ab865e76aec90c
        path=n3hfp53sib8a7kqwq6c3gqm53ff75qrv/nix-2.22.0-x86_64-linux.tar.xz
        system=x86_64-linux
        ;;
    Linux.i?86)
        hash=6e93a5ff954df81ed409cea564c601e83bf3562891fd0fcddc55dc55d421d94e
        path=49prlz6zv8bhq4qx6rhc9fycfs541bn5/nix-2.22.0-i686-linux.tar.xz
        system=i686-linux
        ;;
    Linux.aarch64)
        hash=ce9f163568fb5b34fd3b2f4744febc382c7db27d4e5cbbdfaf59ca38c437e487
        path=49j8yjpw0q4zwyyshm3adqr9533yx795/nix-2.22.0-aarch64-linux.tar.xz
        system=aarch64-linux
        ;;
    Linux.armv6l)
        hash=85648164372815de1646e6566ec937a22822de935283c16340ff653507cc21d6
        path=7c6l3y0gvgykfapd477c0fawj4n8rhkv/nix-2.22.0-armv6l-linux.tar.xz
        system=armv6l-linux
        ;;
    Linux.armv7l)
        hash=fd119989bd881079f1ee508066000315dd96b8eebbe82213f434a46c2a6e4f27
        path=1cfwzxk0gvz5wncxzl0hjpy85l1lpqig/nix-2.22.0-armv7l-linux.tar.xz
        system=armv7l-linux
        ;;
    Darwin.x86_64)
        hash=6e7b20bad1cc648a22cbaed34a9c57d8382f2c179fae8d72b6962436c906489f
        path=wvzxww6bxixvvn0fqrn2p75hm4phfj0q/nix-2.22.0-x86_64-darwin.tar.xz
        system=x86_64-darwin
        ;;
    Darwin.arm64|Darwin.aarch64)
        hash=e040660626f3557a1351735a43f07dea518f8a75670cb79be57c30bcf1603b62
        path=q9s2k0q0ggk0vrs9cmvgw8w33mmgwlkz/nix-2.22.0-aarch64-darwin.tar.xz
        system=aarch64-darwin
        ;;
    *) oops "sorry, there is no binary distribution of Nix for your platform";;
esac

# Use this command-line option to fetch the tarballs using nar-serve or Cachix
if [ "${1:-}" = "--tarball-url-prefix" ]; then
    if [ -z "${2:-}" ]; then
        oops "missing argument for --tarball-url-prefix"
    fi
    url=${2}/${path}
    shift 2
else
    url=https://releases.nixos.org/nix/nix-2.22.0/nix-2.22.0-$system.tar.xz
fi

tarball=$tmpDir/nix-2.22.0-$system.tar.xz

require_util tar "unpack the binary tarball"
if [ "$(uname -s)" != "Darwin" ]; then
    require_util xz "unpack the binary tarball"
fi

if command -v curl > /dev/null 2>&1; then
    fetch() { curl --fail -L "$1" -o "$2"; }
elif command -v wget > /dev/null 2>&1; then
    fetch() { wget "$1" -O "$2"; }
else
    oops "you don't have wget or curl installed, which I need to download the binary tarball"
fi

echo "downloading Nix 2.22.0 binary tarball for $system from '$url' to '$tmpDir'..."
fetch "$url" "$tarball" || oops "failed to download '$url'"

if command -v sha256sum > /dev/null 2>&1; then
    hash2="$(sha256sum -b "$tarball" | cut -c1-64)"
elif command -v shasum > /dev/null 2>&1; then
    hash2="$(shasum -a 256 -b "$tarball" | cut -c1-64)"
elif command -v openssl > /dev/null 2>&1; then
    hash2="$(openssl dgst -r -sha256 "$tarball" | cut -c1-64)"
else
    oops "cannot verify the SHA-256 hash of '$url'; you need one of 'shasum', 'sha256sum', or 'openssl'"
fi

if [ "$hash" != "$hash2" ]; then
    oops "SHA-256 hash mismatch in '$url'; expected $hash, got $hash2"
fi

unpack=$tmpDir/unpack
mkdir -p "$unpack"
tar -xJf "$tarball" -C "$unpack" || oops "failed to unpack '$url'"

script=$(echo "$unpack"/*/install)

[ -e "$script" ] || oops "installation script is missing from the binary tarball!"
export INVOKED_FROM_INSTALL_IN=1
"$script" "$@"

} # End of wrapping
