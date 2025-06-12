#!/bin/bash

DEST=luas

# Cleanup
echo "Cleanin up.."
rm lua-all.tar.gz
# rm -rf 0bf80b07b0672ce874feedcc777afe1b791ccb5a.tar.gz
# rm -rf 69e5342eb893815b18a1ec84ba74b0e0d1cc9beb.tar.gz
# rm -rf 880ca300e8fb7b432b9d25ed377db2102e4cb63d.tar.gz
# rm -rf 21af151af28d4b3524684b106bd19b02484f67f1.tar.gz
# rm -rf e7633dba1e446763454a7969ce7e27139debc6cd.tar.gz
# rm -rf 87d74a8f3d8f5a53fc7ad1fd45adcc06db4bcde8.tar.gz
rm -rf luau-macos.zip

# Remove unused lua versions
for dir in ./$DEST/lua-all/lua-*; do
  version=${dir##*/lua-}
  if [[ "$version" =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
    if [[ "$(printf '%s\n' "$version" 5.3.0 | sort -V | head -n1)" != "5.3.0" ]]; then
      rm -rf "$dir"
    fi
  else
    rm -rf "$dir"
  fi
done
