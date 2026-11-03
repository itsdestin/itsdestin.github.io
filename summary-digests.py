"""Print the sub-summary file names a Flatpak summary.idx points to (one per architecture)."""
import sys
from gi.repository import GLib
data = open(sys.argv[1], 'rb').read()
index = GLib.Variant.new_from_bytes(GLib.VariantType('(a{s(ayaaya{sv})}a{sv})'), GLib.Bytes.new(data), False)
for name, (digest, _history, _meta) in index.unpack()[0].items():
    print(bytes(digest).hex())
