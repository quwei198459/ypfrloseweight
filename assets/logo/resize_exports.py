from PIL import Image
import os

base = os.path.dirname(os.path.abspath(__file__))
mp = [
    ("vFJos.png", "a", "dark"),
    ("NKCLC.png", "a", "light"),
    ("iEcEe.png", "a", "contrast"),
    ("foaTD.png", "b", "dark"),
    ("OUEIO.png", "b", "light"),
    ("MauFv.png", "b", "contrast"),
    ("PW7Ve.png", "c", "dark"),
    ("PRC3t.png", "c", "light"),
    ("HgwBh.png", "c", "contrast"),
]
sizes = [(1024, ""), (512, "-512"), (256, "-256")]

for src, g, variant in mp:
    p = os.path.join(base, src)
    if not os.path.isfile(p):
        continue
    im = Image.open(p).convert("RGBA")
    for dim, suf in sizes:
        out = im.resize((dim, dim), Image.Resampling.LANCZOS)
        name = f"logo-{g}-{variant}{suf}.png"
        out.save(os.path.join(base, name), "PNG")
        print("wrote", name, dim)
    os.remove(p)
