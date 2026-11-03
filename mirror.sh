#!/usr/bin/env bash
# Build the forwarding copy of the OpenSwipe update site into $1 (see README.md).
# WHY a full copy and not only a "moved" note: Steam Decks installed with the Swipe Keyboard installer have their update
# address set explicitly (Flatpak records url-is-set=true), and Flatpak then ignores "moved" notes by design. They keep
# asking the old address, so the old address must keep serving the real, current, signed update site.
set -euo pipefail
OUT="$1"
NEW=https://itsdestin.github.io/openswipe
SITE="$OUT/swipe-keyboard"
REPO="$SITE/repo"
mkdir -p "$SITE"
cp index.html README.md "$OUT/"
: > "$OUT/.nojekyll"
fetch() { mkdir -p "$(dirname "$SITE/$1")"; curl -fsS --retry 5 --retry-all-errors -o "$SITE/$1" "$NEW/$1"; }
# 1. The signed Flatpak summary FIRST, then the objects: a release published in between can then only add objects.
ostree init --repo="$REPO" --mode=archive-z2
for f in config summary summary.sig summary.idx summary.idx.sig; do fetch "repo/$f"; done
for digest in $(python3 summary-digests.py "$REPO/summary.idx"); do fetch "repo/summaries/$digest.gz"; done
# 2. Every object the summary needs (content-addressed: identical bytes, and every commit is signed with our key).
ostree --repo="$REPO" remote add --no-gpg-verify new "$NEW/repo/"
# WHY retries (2026-11-03): GitHub's website sometimes answers "busy, try later" (503) for a moment, and ostree gives up
# at once. A failed run is harmless (the last good copy stays online) but leaves the copy an hour staler.
for try in 1 2 3 4 5; do ostree --repo="$REPO" pull --mirror new && break; [ "$try" = 5 ] && exit 1; sleep $((try * 20)); done
for f in config summary summary.sig summary.idx summary.idx.sig; do fetch "repo/$f"; done   # the published ones, not ostree's
# 3. The native update lists (signed) and Fedora's repository metadata (signed repomd.xml).
fetch arch/latest.json; fetch arch/latest.json.sig
for arch in x86_64 aarch64; do
  fetch "fedora/$arch/repodata/repomd.xml"; fetch "fedora/$arch/repodata/repomd.xml.asc"
  for href in $(grep -o 'href="repodata/[^"]*"' "$SITE/fedora/$arch/repodata/repomd.xml" | cut -d'"' -f2); do fetch "fedora/$arch/$href"; done
done
for folder in deb/kubuntu-26.10 deb/debian-testing opensuse/tumbleweed; do
  if curl -fs -o /dev/null "$NEW/$folder/latest.json"; then fetch "$folder/latest.json"; fetch "$folder/latest.json.sig"; fi
done
for f in swipe-keyboard.flatpakrepo org.itsdestin.SwipeKeyboard.flatpakref org.itsdestin.SwipeKeyboard.GamingHelper.flatpakref; do
  fetch "$f" 2>/dev/null || true
done
# A copy without the two apps' refs would be worse than none: fail the run instead of publishing it.
test -s "$REPO/refs/heads/app/org.itsdestin.SwipeKeyboard/x86_64/master"
test -s "$REPO/refs/heads/app/org.itsdestin.SwipeKeyboard.GamingHelper/x86_64/master"
rm -rf "$REPO/state" "$REPO/tmp" "$REPO/extensions" "$REPO/refs/remotes"
echo "mirrored: $(du -sh "$SITE" | cut -f1)"
