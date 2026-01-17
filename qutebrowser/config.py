import os
from urllib.request import urlopen

config.load_autoconfig()

c.completion.shrink = True
c.colors.webpage.preferred_color_scheme = "dark"
# c.colors.webpage.darkmode.enabled = True

c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "go": "https://pkg.go.dev/search?q={}",
    "aw": "https://wiki.archlinux.org/index.php?search={}",
}

config.bind(",v", "spawn mpv --wayland-app-id=mpv-pip {url}")
config.bind(",V", "hint links spawn mpv  {hint-url}")
