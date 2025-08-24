TEMP_DIR="./temp"

mkdir -p "$TEMP_DIR"

THEME_NAME="where-is-my-sddm-theme"
THEME_URL="https://github.com/stepanzubkov/where-is-my-sddm-theme.git"
SDDM_THEME_DIR="/usr/share/sddm/themes"

[ -d "$TEMP_DIR/$THEME_NAME" ] || git clone "$THEME_URL" "$TEMP_DIR/$THEME_NAME"

sudo -v
[ -d "$SDDM_THEME_DIR/$THEME_NAME" ] || sudo mkdir -p "$SDDM_THEME_DIR/$THEME_NAME"
sudo cp -r "$TEMP_DIR/$THEME_NAME/where_is_my_sddm_theme/." "$SDDM_THEME_DIR/$THEME_NAME/"