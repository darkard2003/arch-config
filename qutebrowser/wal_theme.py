from qutebrowser.api import message
from qutebrowser.config.config import ConfigContainer  # noqa: F401
import os
import json

XDG_HOME = os.getenv("HOME") or "~"
WAL_HOME = os.path.join(XDG_HOME, ".cache", "wal")


def apply_wal_colors(c: ConfigContainer):
    wal_json_path = os.path.join(WAL_HOME, "colors.json")

    if not os.path.exists(wal_json_path):
        message.warning("wal_theme.py: wal colors.json not found")
        return

    try:
        with open(wal_json_path, "r") as f:
            wal_colors = json.load(f)
    except json.JSONDecodeError:
        message.error("wal_theme.py: Invalid JSON in colors.json")
        return

    special = wal_colors.get("special", {})
    bg = special.get("background", "#090404")
    fg = special.get("foreground", "#c1c0c0")

    colors = wal_colors.get("colors", {})

    c0 = colors.get("color0", "#1F1F1F")
    c1 = colors.get("color1", "#D78787")
    c2 = colors.get("color2", "#87AF5F")
    c3 = colors.get("color3", "#D7AF87")
    c4 = colors.get("color4", "#87AFD7")
    c5 = colors.get("color5", "#AF87AF")
    c6 = colors.get("color6", "#87AFAF")
    c7 = colors.get("color7", "#C6C6C6")
    c8 = colors.get("color8", "#444444")
    c9 = colors.get("color9", "#D78787")
    c10 = colors.get("color10", "#87AF5F")
    c11 = colors.get("color11", "#D7AF87")
    c12 = colors.get("color12", "#87AFD7")
    c13 = colors.get("color13", "#AF87AF")
    c14 = colors.get("color14", "#87AFAF")
    c15 = colors.get("color15", "#C6C6C6")

    # Completion menu colors
    c.colors.completion.fg = fg
    c.colors.completion.category.bg = bg
    c.colors.completion.category.fg = fg
    c.colors.completion.category.border.top = c1
    c.colors.completion.category.border.bottom = c1
    c.colors.completion.even.bg = c2
    c.colors.completion.odd.bg = c1
    c.colors.completion.item.selected.bg = c7
    c.colors.completion.item.selected.fg = c0
    c.colors.completion.item.selected.border.bottom = c0
    c.colors.completion.item.selected.border.top = c0
    c.colors.completion.item.selected.match.fg = c8
    c.colors.completion.match.fg = c3
    c.colors.completion.scrollbar.bg = bg
    c.colors.completion.scrollbar.fg = fg

    # Status bar colors
    c.colors.statusbar.normal.bg = bg
    c.colors.statusbar.normal.fg = fg
    c.colors.statusbar.insert.bg = c1
    c.colors.statusbar.insert.fg = c7
    c.colors.statusbar.url.fg = fg
    c.colors.statusbar.url.success.http.fg = fg
    c.colors.statusbar.url.success.https.fg = fg

    c.colors.tabs.bar.bg = bg
    c.colors.tabs.odd.bg = c1
    c.colors.tabs.odd.fg = fg
    c.colors.tabs.even.bg = c1
    c.colors.tabs.even.fg = fg
    c.colors.tabs.selected.even.fg = fg
    c.colors.tabs.selected.even.bg = bg
    c.colors.tabs.indicator.start = c6
    c.colors.tabs.indicator.stop = c7
    c.colors.tabs.indicator.error = c3
