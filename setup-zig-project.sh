#!/bin/bash

# Initialize Zig project
zig init
rm src/root.zig

# Install Libraries
zig fetch --save=ac-library git+https://github.com/Ryoga-exe/ac-library-zig#v0.4.0

zig fetch --save=proconio git+https://github.com/Ryoga-exe/proconio-zig#v0.3.0

pushd /tmp

# zig-string with patch
git clone https://github.com/JakubSzark/zig-string
wget -nv -O string.patch https://github.com/JakubSzark/zig-string/pull/55.patch
pushd zig-string
git checkout f6f9e5dc7c5c45a72473de245a0e6958ef2bf913
patch -p1 < ../string.patch
popd

# mvzr with patch
git clone https://github.com/mnemnion/mvzr
wget -nv -O mvzr.patch https://github.com/mnemnion/mvzr/pull/10.patch
pushd mvzr
git checkout v0.3.6
patch -p1 < ../mvzr.patch
popd

popd

# Add local dependencies
zig fetch --save=string /tmp/zig-string
zig fetch --save=mvzr /tmp/mvzr

# Test build
zig build --release -Doptimize=ReleaseFast
./zig-out/bin/judge
rm zig-out/bin/judge