# itsdestin.github.io

This site exists for one reason: **Swipe Keyboard was renamed to [OpenSwipe](https://github.com/itsdestin/openswipe)**
on 2026-11-02. GitHub forwards the old project and download addresses, but not the old update website
(`itsdestin.github.io/swipe-keyboard/`). Keyboards installed before the rename still ask that address for updates.

`swipe-keyboard/` is a complete copy of the live OpenSwipe update site, refreshed every hour by
`.github/workflows/mirror.yml` (`mirror.sh`). WHY a full copy: Steam Decks installed with the Swipe Keyboard installer
have their update address set explicitly, and Flatpak then ignores "moved" notes by design, so they keep asking this
address. Arch and Fedora installs older than 0.5.1-1 also ask only here.

Every file is signed with the OpenSwipe update key and checked by the keyboard before use, so nothing here can
change what gets installed. Keep this site until at least November 2027.

**Never create a repository named `swipe-keyboard` on this account:** it would take over the old address and break
GitHub's forwarding of old download links.
