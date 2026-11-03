# itsdestin.github.io

This site exists for one reason: **Swipe Keyboard was renamed to [OpenSwipe](https://github.com/itsdestin/openswipe)**
on 2026-11-02. GitHub forwards the old project and download addresses, but not the old update website
(`itsdestin.github.io/swipe-keyboard/`). Keyboards installed before the rename still ask that address for updates.

`swipe-keyboard/` holds exact, unchanged copies of the signed update files as published for version 0.5.1-1. They
tell every older install where the project moved:
- Steam Deck / Flatpak: the signed summary carries `redirect-url = https://itsdestin.github.io/openswipe/repo/`;
  a Deck switches to it on its next daily check.
- Arch and Fedora: the signed 0.5.1-1 update lists; that version already knows the new address.

Every file is signed with the OpenSwipe update key and checked by the keyboard before use, so nothing here can
change what gets installed. Keep this site until at least November 2027.

**Never create a repository named `swipe-keyboard` on this account:** it would take over the old address and break
GitHub's forwarding of old download links.
