#!/bin/bash

DEST=luas

if [ ! -d "./$DEST" ]; then
  mkdir -p ./$DEST
fi

# Download all Lua versions archive
echo "Downloading lua-all.."
curl -L -o lua-all.tar.gz https://www.lua.org/ftp/lua-all.tar.gz >/dev/null 2>&1
tar -xzf lua-all.tar.gz -C ./$DEST

#Lua-JIT
echo "Downloading Lua-JIT.."
# LuaJIT Newest
cd $DEST && git clone https://luajit.org/git/luajit.git >/dev/null 2>&1 && cd ..

# # LuaJIT 2.0.5
# curl -LO https://repo.or.cz/luajit-2.0.git/snapshot/0bf80b07b0672ce874feedcc777afe1b791ccb5a.tar.gz >/dev/null 2>&1
# tar -xzf 0bf80b07b0672ce874feedcc777afe1b791ccb5a.tar.gz 
# mv luajit-2.0-0bf80b0 ./$DEST/lua-jit-2.0.5
# # LuaJIT 2.0.4
# curl -LO https://repo.or.cz/luajit-2.0.git/snapshot/69e5342eb893815b18a1ec84ba74b0e0d1cc9beb.tar.gz >/dev/null 2>&1
# tar -xzf 69e5342eb893815b18a1ec84ba74b0e0d1cc9beb.tar.gz
# mv luajit-2.0-69e5342 ./$DEST/lua-jit-2.0.4
# # LuaJIT 2.0.3
# curl -LO https://repo.or.cz/luajit-2.0.git/snapshot/880ca300e8fb7b432b9d25ed377db2102e4cb63d.tar.gz >/dev/null 2>&1
# tar -xzf 880ca300e8fb7b432b9d25ed377db2102e4cb63d.tar.gz
# mv luajit-2.0-880ca30 ./$DEST/lua-jit-2.0.3
# # LuaJIT 2.0.2
# curl -LO https://repo.or.cz/luajit-2.0.git/snapshot/21af151af28d4b3524684b106bd19b02484f67f1.tar.gz >/dev/null 2>&1
# tar -xzf 21af151af28d4b3524684b106bd19b02484f67f1.tar.gz
# mv luajit-2.0-21af151 ./$DEST/lua-jit-2.0.2
# # LuaJIT 2.0.1 FIXED
# curl -LO https://repo.or.cz/luajit-2.0.git/snapshot/e7633dba1e446763454a7969ce7e27139debc6cd.tar.gz >/dev/null 2>&1
# tar -xzf e7633dba1e446763454a7969ce7e27139debc6cd.tar.gz
# mv luajit-2.0-e7633db ./$DEST/lua-jit-2.0.1
# # LuaJIT 2.0
# curl -LO https://repo.or.cz/luajit-2.0.git/snapshot/87d74a8f3d8f5a53fc7ad1fd45adcc06db4bcde8.tar.gz >/dev/null 2>&1
# tar -xzf 87d74a8f3d8f5a53fc7ad1fd45adcc06db4bcde8.tar.gz
# mv luajit-2.0-87d74a8 ./$DEST/lua-jit-2.0

# Lua-AOT
echo "Downloading Lua-AOT.."
cd $DEST && git clone https://github.com/hugomg/lua-aot-5.4.git >/dev/null 2>&1 && cd ..

# Luau
echo "Downloading Luau.."
curl -L -o luau-macos.zip https://github.com/luau-lang/luau/releases/download/0.669/luau-macos.zip >/dev/null 2>&1
unzip luau-macos.zip -d ./$DEST/luau >/dev/null 2>&1

# # Lua-JIT-REMAKE
# echo "Downloading Lua-JIT-REMAKE.."
# cd $DEST && git clone https://github.com/luajit-remake/luajit-remake.git >/dev/null 2>&1 && cd ..