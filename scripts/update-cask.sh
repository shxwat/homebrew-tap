#!/bin/zsh
# Updates Casks/silknest.rb to a new release: version and the DMG's SHA-256.
#   zsh scripts/update-cask.sh 1.3.1                       # downloads the DMG from the GitHub release
#   zsh scripts/update-cask.sh 1.3.1 path/to/SilkNest-1.3.1.dmg   # or uses the local file (same bytes!)
# Then: git commit -am "silknest 1.3.1" && git push
set -euo pipefail
VERSION="${1:?version}"
DMG="${2:+${2:A}}"          # absolute, before changing folder
cd "${0:A:h}/.."
if [[ -z "$DMG" ]]; then
  DMG="$(mktemp -d)/SilkNest-$VERSION.dmg"
  curl -fL --proto '=https' -o "$DMG" "https://github.com/shxwat/silknest/releases/download/v$VERSION/SilkNest-$VERSION.dmg"
fi
SHA=$(shasum -a 256 "$DMG" | cut -c1-64)
sed -i '' -E "s/^  version \"[^\"]*\"/  version \"$VERSION\"/; s/^  sha256 \"[0-9a-f]*\"/  sha256 \"$SHA\"/" Casks/silknest.rb
grep -E '^  (version|sha256) ' Casks/silknest.rb
ruby -c Casks/silknest.rb >/dev/null && echo "Casks/silknest.rb updated to $VERSION"
