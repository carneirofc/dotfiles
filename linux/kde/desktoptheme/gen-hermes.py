#!/usr/bin/env python3
"""Generate the "Hermes" Plasma Style's widget-card SVGs.

Desktop widgets get a WezTerm-like card: the scheme's view background
(the terminal background matugen writes) slightly translucent, rounded
corners, and a faint hairline in the accent color, like the Hermes app.
Colors are ColorScheme-* classes, so the cards follow matugen live.

Run after tweaking the constants: ./gen-hermes.py
"""
from pathlib import Path

C = 12          # corner tile size
R = 8.0         # corner radius (WezTerm/Hermes use ~8px)
E = 24          # edge tile length
MARGIN = 12     # content padding inside the card
FILL_OPACITY = 0.86
BORDER_OPACITY = 0.30
W = H = C * 2 + E

STYLE = """<style type="text/css" id="current-color-scheme">
  .ColorScheme-ViewBackground { color:#161217; }
  .ColorScheme-Highlight { color:#e0b8f6; }
</style>"""

FILL = f'class="ColorScheme-ViewBackground" style="fill:currentColor;fill-opacity:{FILL_OPACITY};stroke:none"'
# Borders are filled shapes, not strokes: KSvg sizes tiles from element bounds,
# and a stroke's half-width spills past the tile and garbles the corners.
LINE = f'class="ColorScheme-Highlight" style="fill:currentColor;fill-opacity:{BORDER_OPACITY};fill-rule:evenodd;stroke:none"'
PIN = 'style="fill:#000000;fill-opacity:0;stroke:none"'  # pins each tile's bounds


def corner(name, ox, oy, fx, fy):
    """Top-left corner geometry mirrored by (fx, fy) into the tile at (ox, oy)."""
    def p(x, y):
        x = C - x if fx else x
        y = C - y if fy else y
        return f"{ox + x:g},{oy + y:g}"
    sweep = 0 if fx == fy else 1
    ri = R - 1
    outer = f"M{p(C, 0)} L{p(R, 0)} A{R:g},{R:g} 0 0 {sweep} {p(0, R)} L{p(0, C)} L{p(C, C)} Z"
    inner = f"M{p(C, 1)} L{p(R, 1)} A{ri:g},{ri:g} 0 0 {sweep} {p(1, R)} L{p(1, C)} L{p(C, C)} Z"
    return (f'<g id="{name}"><rect {PIN} x="{ox}" y="{oy}" width="{C}" height="{C}"/>'
            f'<path {FILL} d="{inner}"/><path {LINE} d="{outer} {inner}"/></g>')


def edge(name, x, y, w, h, side):
    fx, fy, fw, fh = x, y, w, h          # fill rect
    bx, by, bw, bh = x, y, w, h          # 1px border rect
    if side == "top":
        fy, fh, bh = y + 1, h - 1, 1
    elif side == "bottom":
        fh, by, bh = h - 1, y + h - 1, 1
    elif side == "left":
        fx, fw, bw = x + 1, w - 1, 1
    else:
        fw, bx, bw = w - 1, x + w - 1, 1
    return (f'<g id="{name}"><rect {PIN} x="{x}" y="{y}" width="{w}" height="{h}"/>'
            f'<rect {FILL} x="{fx}" y="{fy}" width="{fw}" height="{fh}"/>'
            f'<rect {LINE} x="{bx}" y="{by}" width="{bw}" height="{bh}"/></g>')


def build():
    m = C + E  # far tile origin
    parts = [
        corner("topleft", 0, 0, False, False),
        corner("topright", m, 0, True, False),
        corner("bottomleft", 0, m, False, True),
        corner("bottomright", m, m, True, True),
        edge("top", C, 0, E, C, "top"),
        edge("bottom", C, m, E, C, "bottom"),
        edge("left", 0, C, C, E, "left"),
        edge("right", m, C, C, E, "right"),
        f'<rect id="center" {FILL} x="{C}" y="{C}" width="{E}" height="{E}"/>',
        # Hints live off-canvas; only their size matters.
        f'<rect id="hint-top-margin" x="{W + 10}" y="0" width="4" height="{MARGIN}" style="fill:none"/>',
        f'<rect id="hint-bottom-margin" x="{W + 16}" y="0" width="4" height="{MARGIN}" style="fill:none"/>',
        f'<rect id="hint-left-margin" x="{W + 22}" y="0" width="{MARGIN}" height="4" style="fill:none"/>',
        f'<rect id="hint-right-margin" x="{W + 22}" y="6" width="{MARGIN}" height="4" style="fill:none"/>',
        f'<rect id="hint-stretch-borders" x="{W + 22}" y="12" width="4" height="4" style="fill:none"/>',
    ]
    body = "\n  ".join(parts)
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{W + 40}" height="{H}">\n'
            f'  <defs>{STYLE}</defs>\n  {body}\n</svg>\n')


if __name__ == "__main__":
    root = Path(__file__).resolve().parent / "hermes"
    svg = build()
    for rel in ("widgets/background.svg",
                "widgets/translucentbackground.svg",
                "translucent/widgets/background.svg",
                "solid/widgets/background.svg"):
        out = root / rel
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(svg)
        print("wrote", out.relative_to(root.parent))
