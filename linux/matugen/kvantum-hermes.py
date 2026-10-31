#!/usr/bin/env python3
"""Build the "Hermes" Kvantum theme (Qt app style) from the matugen palette.

Starts from Kvantum's flat dark KvFlat theme and retints it so Qt/KDE apps
(Dolphin, Kate, System Settings...) look like WezTerm and the Hermes app:
- the background is the terminal's (matugen surface), slightly translucent
  with KWin blur behind it, like WezTerm's window_background_opacity;
- the accent (selection, focus, active tabs, sliders) is matugen primary;
- KvFlat's grays keep their relative lightness but shift to the surface tint.

Reads the generated KDE scheme, so it runs after matugen writes it (the kde
template's post_hook) and from linux/kde/apply.sh. Running apps pick the
new colors up on restart.

Usage: kvantum-hermes.py [--scheme PATH] [--out DIR]
"""
import argparse
import colorsys
import configparser
import re
from pathlib import Path

BASE_THEME = Path("/usr/share/Kvantum/KvFlat")
SCHEME = Path.home() / ".local/share/color-schemes/Matugen.colors"
OUT = Path.home() / ".config/Kvantum/Hermes"
NAME = "Hermes"

WINDOW_OPACITY = 18   # % less opaque; 10 (WezTerm's 0.9) reads as solid here
ALT_ROW_ALPHA = 0x0a  # alternating-row wash, ~4%
MENU_OPACITY = 8
# Plasma-popup look (task manager menu): rounded items with a hairline.
SELECTION_FILL = 0.16     # accent wash behind selected items
ITEM_RADIUS, ITEM_FRAME = 5, 5     # selection box corner radius / tile size
POPUP_RADIUS, POPUP_FRAME = 8, 8   # menus and tooltips
POPUP_FILL = 0.88
# Tabs (Dolphin, Kate...): flat, left-aligned, joined, browser-like; the active
# one gets an accent wash and underline, the rest sit on a faint baseline.
TAB_RADIUS, TAB_FRAME = 4, 4
TAB_UNDERLINE = 2          # px, active tab
TAB_ACTIVE_FILL = 0.12
TAB_HOVER_FILL = 0.06
TAB_BASELINE = 0.12        # hairline under inactive tabs
# KvFlat's own view background; its lightness is pinned to the surface's.
KVFLAT_BASE_L = colorsys.rgb_to_hls(*(c / 255 for c in (0x2E, 0x2E, 0x2E)))[1]
KVFLAT_ACCENT_L = colorsys.rgb_to_hls(*(c / 255 for c in (0x3D, 0xAE, 0xE9)))[1]


def rgb(scheme, group, key):
    return tuple(int(v) for v in scheme[f"Colors:{group}"][key].split(","))


def hexa(c, alpha=None):
    s = "#%02x%02x%02x" % c
    return s if alpha is None else s + "%02x" % alpha


def hls(c):
    return colorsys.rgb_to_hls(*(v / 255 for v in c))


def from_hls(h, l, s):
    return tuple(round(max(0, min(1, v)) * 255) for v in colorsys.hls_to_rgb(h, l, s))


def make_recolor(surface, primary):
    sh, sl, ss = hls(surface)
    ph, pl, ps = hls(primary)

    def recolor(m):
        h, l, s = hls(tuple(int(m.group(1)[i:i + 2], 16) for i in (0, 2, 4)))
        if s < 0.25:  # gray: same relative lightness, surface hue/tint
            if l <= KVFLAT_BASE_L:
                nl = l * sl / KVFLAT_BASE_L
            else:
                nl = sl + (l - KVFLAT_BASE_L) * (1 - sl) / (1 - KVFLAT_BASE_L)
            return hexa(from_hls(sh, nl, min(ss, 0.12)))
        # accent (KvFlat's Breeze blues): primary hue; keep shades close to
        # primary so darker states stay soft lavender, not neon
        return hexa(from_hls(ph, pl - (KVFLAT_ACCENT_L - l) * 0.6, ps * 0.75))

    return recolor


def soften_selection(svg, rounded):
    """Retire KvFlat's square selection/menu/tooltip elements (renamed, so
    Kvantum ignores them) and append rounded Plasma-popup-style ones."""
    pat = (r'id="((?:itemview|menuitem)-(?:focused|pressed|toggled)'
           r'(?:-(?:top|bottom|left|right|topleft|topright|bottomleft|bottomright))?'
           r'|menu-(?:normal|shadow)[^"]*|tooltip-(?:normal|shadow)[^"]*'
           r'|(?:floating-)?tab-(?:normal|focused|toggled)[^"]*)"')
    svg = re.sub(pat, r'id="kvflat-\1"', svg)
    return svg.replace("</svg>", rounded + "\n</svg>")


def nine_slice(name, x0, fill, border, r, f):
    """Kvantum frame + interior: '<name>' interior and '<name>-<pos>' frames.
    Corners are f x f tiles with radius r; borders are filled 1px shapes
    (strokes spill outside element bounds and garble the tiles)."""
    E = 8                       # edge/interior tile length
    W = 2 * f + E
    pin = 'style="fill:#000;fill-opacity:0"'
    F = f'style="fill:{fill[0]};fill-opacity:{fill[1]}"'
    B = f'style="fill:{border[0]};fill-opacity:{border[1]};fill-rule:evenodd"'
    out = [f'<rect id="{name}" {F} x="{x0 + f}" y="{f}" width="{E}" height="{E}"/>']

    def corner(pos, ox, oy, fx, fy):
        def p(x, y):
            return f"{ox + (f - x if fx else x):g},{oy + (f - y if fy else y):g}"
        sw = 0 if fx == fy else 1
        ri = max(r - 1, 0)
        outer = f"M{p(f, 0)} L{p(r, 0)} A{r},{r} 0 0 {sw} {p(0, r)} L{p(0, f)} L{p(f, f)} Z"
        inner = f"M{p(f, 1)} L{p(r, 1)} A{ri},{ri} 0 0 {sw} {p(1, r)} L{p(1, f)} L{p(f, f)} Z"
        out.append(f'<g id="{name}-{pos}"><rect {pin} x="{ox}" y="{oy}" width="{f}" height="{f}"/>'
                   f'<path {F} d="{inner}"/><path {B} d="{outer} {inner}"/></g>')

    def edge(pos, x, y, w, h):
        fx, fy, fw, fh, bx, by, bw, bh = x, y, w, h, x, y, w, h
        if pos == "top":
            fy, fh, bh = y + 1, h - 1, 1
        elif pos == "bottom":
            fh, by, bh = h - 1, y + h - 1, 1
        elif pos == "left":
            fx, fw, bw = x + 1, w - 1, 1
        else:
            fw, bx, bw = w - 1, x + w - 1, 1
        out.append(f'<g id="{name}-{pos}"><rect {pin} x="{x}" y="{y}" width="{w}" height="{h}"/>'
                   f'<rect {F} x="{fx}" y="{fy}" width="{fw}" height="{fh}"/>'
                   f'<rect {B} x="{bx}" y="{by}" width="{bw}" height="{bh}"/></g>')

    m = f + E
    corner("topleft", x0, 0, False, False)
    corner("topright", x0 + m, 0, True, False)
    corner("bottomleft", x0, m, False, True)
    corner("bottomright", x0 + m, m, True, True)
    edge("top", x0 + f, 0, E, f)
    edge("bottom", x0 + f, m, E, f)
    edge("left", x0, f, f, E)
    edge("right", x0 + m, f, f, E)
    return "\n".join(out), W


def tab_slice(name, x0, fill, line, line_w, r, f):
    """Tab 9-slice: rounded top corners, square bottom, and a bottom line
    (accent underline or baseline hairline) of line_w px. No side borders,
    so joined tabs read as one strip rather than a row of buttons."""
    E = 8
    W = 2 * f + E
    pin = 'style="fill:#000;fill-opacity:0"'
    F = f'style="fill:{fill[0]};fill-opacity:{fill[1]}"'
    L = f'style="fill:{line[0]};fill-opacity:{line[1]}"'
    m = f + E
    out = [f'<rect id="{name}" {F} x="{x0 + f}" y="{f}" width="{E}" height="{E}"/>']

    def tile(pos, x, y, w, h, body):
        out.append(f'<g id="{name}-{pos}"><rect {pin} x="{x}" y="{y}" width="{w}" height="{h}"/>{body}</g>')

    # top corners: quarter-rounded fill
    tile("topleft", x0, 0, f, f,
         f'<path {F} d="M{x0},{f} L{x0},{r} A{r},{r} 0 0 1 {x0 + r},0 L{x0 + f},0 L{x0 + f},{f} Z"/>')
    xr = x0 + m
    tile("topright", xr, 0, f, f,
         f'<path {F} d="M{xr},0 L{xr + f - r},0 A{r},{r} 0 0 1 {xr + f},{r} L{xr + f},{f} L{xr},{f} Z"/>')
    tile("top", x0 + f, 0, E, f, f'<rect {F} x="{x0 + f}" y="0" width="{E}" height="{f}"/>')
    tile("left", x0, f, f, E, f'<rect {F} x="{x0}" y="{f}" width="{f}" height="{E}"/>')
    tile("right", xr, f, f, E, f'<rect {F} x="{xr}" y="{f}" width="{f}" height="{E}"/>')
    # bottom row: fill above, line along the bottom edge
    for pos, x, w in (("bottomleft", x0, f), ("bottom", x0 + f, E), ("bottomright", xr, f)):
        tile(pos, x, m, w, f,
             f'<rect {F} x="{x}" y="{m}" width="{w}" height="{f - line_w}"/>'
             f'<rect {L} x="{x}" y="{m + f - line_w}" width="{w}" height="{line_w}"/>')
    return "\n".join(out), W


def close_icon(name, x0, color, alpha, bg=None):
    """16px tab close 'x' (KvFlat has none, so Kvantum's boxed default shows)."""
    pin = 'style="fill:#000;fill-opacity:0"'
    body = f'<rect {pin} x="{x0}" y="0" width="16" height="16"/>'
    if bg:
        body += f'<circle style="fill:{bg[0]};fill-opacity:{bg[1]}" cx="{x0 + 8}" cy="8" r="7"/>'
    body += (f'<path style="fill:none;stroke:{color};stroke-opacity:{alpha};stroke-width:1.5;'
             f'stroke-linecap:round" d="M{x0 + 5},5 L{x0 + 11},11 M{x0 + 11},5 L{x0 + 5},11"/>')
    return f'<g id="{name}">{body}</g>'


def build_tabs(primary, text, x):
    p, t = hexa(primary), hexa(text)
    clear = (t, 0)
    parts = []
    # floating-tab-* is what document-mode tab bars (Dolphin, Kate) use;
    # KvFlat draws those as boxed buttons, so give both sets the tab look.
    for prefix in ("tab", "floating-tab"):
        for state, fill, line, lw in (
            ("normal", clear, (t, TAB_BASELINE), 1),
            ("focused", (t, TAB_HOVER_FILL), (t, 0.25), 1),
            ("toggled", (p, TAB_ACTIVE_FILL), (p, 1), TAB_UNDERLINE),
        ):
            svg, w = tab_slice(f"{prefix}-{state}", x, fill, line, lw, TAB_RADIUS, TAB_FRAME)
            parts.append(svg)
            x += w + 10
    for name, c, a, bg in (
        ("tab-close-normal", t, 0.55, None),
        ("tab-close-focused", t, 0.95, (t, 0.12)),
        ("tab-close-pressed", p, 1, (p, 0.25)),
        ("tab-close-disabled", t, 0.25, None),
        ("tab-close-toggled", t, 0.75, None),
        ("tab-close-toggledFocused", t, 0.95, (t, 0.12)),
        ("tab-close-toggledPressed", p, 1, (p, 0.25)),
    ):
        parts.append(close_icon(name, x, c, a, bg))
        x += 26
    return "\n".join(parts), x


def build_rounded(surface, primary, text):
    s, p, t = hexa(surface), hexa(primary), hexa(text)
    specs = [
        # (element, fill, border, radius, frame width) — like Plasma popups:
        # hover = faint wash + hairline, selected = accent wash + accent line.
        ("itemview-focused", (t, 0.05), (p, 0.30), ITEM_RADIUS, ITEM_FRAME),
        ("itemview-pressed", (p, 0.22), (p, 0.70), ITEM_RADIUS, ITEM_FRAME),
        ("itemview-toggled", (p, SELECTION_FILL), (p, 0.60), ITEM_RADIUS, ITEM_FRAME),
        ("menuitem-focused", (p, SELECTION_FILL), (p, 0.60), ITEM_RADIUS, ITEM_FRAME),
        ("menuitem-pressed", (p, 0.22), (p, 0.70), ITEM_RADIUS, ITEM_FRAME),
        ("menuitem-toggled", (p, SELECTION_FILL), (p, 0.60), ITEM_RADIUS, ITEM_FRAME),
        ("menu-normal", (s, POPUP_FILL), (t, 0.14), POPUP_RADIUS, POPUP_FRAME),
        ("tooltip-normal", (s, POPUP_FILL), (t, 0.14), POPUP_RADIUS, POPUP_FRAME),
    ]
    parts, x = [], 10000          # far right of KvFlat's canvas
    for name, fill, border, r, f in specs:
        svg, w = nine_slice(name, x, fill, border, r, f)
        parts.append(svg)
        x += w + 10
    tabs, x = build_tabs(primary, text, x)
    parts.append(tabs)
    return "<g id=\"hermes-rounded\">\n" + "\n".join(parts) + "\n</g>"


def kvconfig(base_cfg, scheme):
    surface = rgb(scheme, "View", "BackgroundNormal")
    alt = rgb(scheme, "View", "BackgroundAlternate")
    button = rgb(scheme, "Button", "BackgroundNormal")
    text = rgb(scheme, "View", "ForegroundNormal")
    inactive = rgb(scheme, "View", "ForegroundInactive")
    primary = rgb(scheme, "Selection", "BackgroundNormal")
    on_primary = rgb(scheme, "Selection", "ForegroundNormal")
    sel_alt = rgb(scheme, "Selection", "BackgroundAlternate")
    link = rgb(scheme, "View", "ForegroundLink")
    visited = rgb(scheme, "View", "ForegroundVisited")
    h, l, s = hls(surface)

    general = {
        "author": "carneirofc (from KvFlat by Tsu Jan)",
        "comment": "KvFlat retinted from matugen; WezTerm/Hermes look. Generated by kvantum-hermes.py",
        "composite": "true",
        "translucent_windows": "true",
        "reduce_window_opacity": str(WINDOW_OPACITY),
        "reduce_menu_opacity": str(MENU_OPACITY),
        "blurring": "true",
        "popup_blurring": "true",
        "menu_blur_radius": str(POPUP_RADIUS),
        "tooltip_blur_radius": str(POPUP_RADIUS),
        "menu_shadow_depth": "0",   # KvFlat's shadow tiles are retired
        "tooltip_shadow_depth": "0",
        # Tabs as a left-aligned strip, not centered floating buttons.
        # (Kvantum always centers unless left_tabs is on.)
        "left_tabs": "true",
        "center_doc_tabs": "false",
        "center_normal_tabs": "false",
        "joined_inactive_tabs": "true",
        "attach_active_tab": "false",
        "no_inactive_tab_expansion": "true",
    }
    colors = {
        "window.color": hexa(surface),
        "base.color": hexa(surface),
        # Alternating rows are painted with this as-is: a solid color makes
        # every other row opaque. A faint text-colored wash keeps them glassy.
        "alt.base.color": hexa(text, ALT_ROW_ALPHA),
        "button.color": hexa(button),
        "light.color": hexa(from_hls(h, l + 0.16, s)),
        "mid.light.color": hexa(from_hls(h, l + 0.10, s)),
        "dark.color": hexa(from_hls(h, l * 0.5, s)),
        "mid.color": hexa(from_hls(h, l + 0.05, s)),
        "highlight.color": hexa(primary),
        "inactive.highlight.color": hexa(sel_alt),
        "text.color": hexa(text),
        "window.text.color": hexa(text),
        "button.text.color": hexa(text),
        "disabled.text.color": hexa(inactive, 0x99),
        "tooltip.text.color": hexa(text),
        # Selections are a translucent accent wash (soften_selection), so the
        # text on them stays light instead of on_primary.
        "highlight.text.color": hexa(text),
        "link.color": hexa(link),
        "link.visited.color": hexa(visited),
        "progress.indicator.text.color": hexa(on_primary),
    }
    hacks = {
        # Let the translucent window show through Dolphin's file view.
        "transparent_dolphin_view": "true",
        "transparent_ktitle_label": "true",
        "respect_darkness": "true",
        "blur_konsole": "true",
    }
    light = hexa(text)
    def frame(n):
        return {f"frame.{k}": str(n) for k in ("top", "bottom", "left", "right")}
    itemview = {
        **frame(ITEM_FRAME),
        "text.normal.color": light,
        "text.focus.color": light,
        "text.press.color": light,
        "text.toggle.color": light,
    }

    out, section = [], None
    overrides = {"%General": general, "GeneralColors": colors, "Hacks": hacks,
                 "ItemView": itemview,
                 "Tab": {**frame(TAB_FRAME),
                         "text.normal.color": hexa(inactive),
                         "text.focus.color": light,
                         "text.press.color": light,
                         "text.toggle.color": light},
                 "MenuItem": {**frame(ITEM_FRAME), "frame": "true"},
                 "Menu": {**frame(POPUP_FRAME), "frame": "true", "interior": "true"},
                 "ToolTip": {**frame(POPUP_FRAME), "frame": "true", "interior": "true"}}
    seen = {k: set() for k in overrides}

    def flush(sec):
        if sec in overrides:
            tail = []
            while out and not out[-1].strip():
                tail.append(out.pop())
            for k, v in overrides[sec].items():
                if k not in seen[sec]:
                    out.append(f"{k}={v}")
            out.extend(tail)

    for line in base_cfg.splitlines():
        m = re.match(r"^\[(.+)\]\s*$", line)
        if m:
            flush(section)
            section = m.group(1)
            out.append(line)
            continue
        k = line.split("=", 1)[0].strip()
        if section in overrides and "=" in line and k in overrides[section]:
            out.append(f"{k}={overrides[section][k]}")
            seen[section].add(k)
        else:
            out.append(line)
    flush(section)
    return "\n".join(out) + "\n"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--scheme", type=Path, default=SCHEME)
    ap.add_argument("--out", type=Path, default=OUT)
    args = ap.parse_args()

    if not (BASE_THEME / "KvFlat.svg").exists():
        raise SystemExit(f"{BASE_THEME} missing: pacman -S kvantum")
    if not args.scheme.exists():
        raise SystemExit(f"{args.scheme} missing: run matugen (set-wallpaper.sh) first")

    scheme = configparser.ConfigParser(interpolation=None)
    scheme.optionxform = str
    scheme.read(args.scheme)
    surface = rgb(scheme, "View", "BackgroundNormal")
    primary = rgb(scheme, "Selection", "BackgroundNormal")

    svg = (BASE_THEME / "KvFlat.svg").read_text()
    # Expand 3-digit colors (#555) so the recolor below catches them too.
    svg = re.sub(r"#([0-9a-fA-F])([0-9a-fA-F])([0-9a-fA-F])(?![0-9a-fA-F])",
                 lambda m: "#" + "".join(c * 2 for c in m.groups()), svg)
    recolor = make_recolor(surface, primary)
    svg = re.sub(r"#([0-9a-fA-F]{6})\b", recolor, svg)
    text = rgb(scheme, "View", "ForegroundNormal")
    svg = soften_selection(svg, build_rounded(surface, primary, text))
    # Per-widget text colors in KvFlat are Breeze blues/cyans too; retint them
    # (GeneralColors gets replaced wholesale afterwards).
    base_cfg = re.sub(r"#([0-9a-fA-F]{6})\b", recolor,
                      (BASE_THEME / "KvFlat.kvconfig").read_text())
    cfg = kvconfig(base_cfg, scheme)

    args.out.mkdir(parents=True, exist_ok=True)
    (args.out / f"{NAME}.svg").write_text(svg)
    (args.out / f"{NAME}.kvconfig").write_text(cfg)
    print(f"Kvantum theme {NAME} written to {args.out}")


if __name__ == "__main__":
    main()
