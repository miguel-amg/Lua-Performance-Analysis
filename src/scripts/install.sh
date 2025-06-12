#!/bin/bash

DEST=luas
PLATFORM=macosx

echo "Installing Lua versions.."
(
  cd ./$DEST/lua-all && make >/dev/null 2>&1
  ./lua-5.4.7/lua -v
)

echo "Installing Lua-JIT versions.."
(
	export MACOSX_DEPLOYMENT_TARGET=11.0
    cd "$DEST/luajit" && make CC=gcc-14 >/dev/null 2>&1 && sudo make CC=gcc-14 install >/dev/null 2>&1
	./src/luajit -v
)

echo "Installing Lua-AOT.."
(
cd ./$DEST/lua-aot-5.4 && make $PLATFORM >/dev/null 2>&1
)

# echo "Installing Lua-JIT-REMAKE.."
# (
# cd ./$DEST/luajit-remake && python3 ljr-build make release >/dev/null 2>&1
# )