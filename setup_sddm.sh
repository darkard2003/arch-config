TEMP_DIR="temp"

if [ ! -d "$TEMP_DIR" ]; then
    mkdir $TEMP_DIR
fi

THEME_NAME="where-is-my-sddm-theme"
THEME_URL="https://github.com/stepanzubkov/where-is-my-sddm-theme.git"
CATPPUCCIN_THEME_NAME="where-is-my-sddm-theme-catppuccin"
CATPPUCCIN_THEME_URL="https://github.com/catppuccin/where-is-my-sddm-theme.git"
SDDM_THEME_DIR="/usr/share/sddm/themes"

git clone "$CATPPUCCIN_THEME_URL" "$TEMP_DIR/$CATPPUCCIN_THEME_NAME"
git clone "$THEME_URL" "$TEMP_DIR/$THEME_NAME"

sudo -v
sudo mkdir -p "$SDDM_THEME_DIR/$THEME_NAME"
sudo cp "$TEMP_DIR/$THEME_NAME/where_is_my_sddm_theme/*"  "$SDDM_THEME_DIR/$THEME_NAME" -r
sudo cp "$TEMP_DIR/$CATPPUCCIN_THEME_NAME/themes/catppuccin-mocha.conf" "$SDDM_THEME_DIR/$THEME_NAME/theme.conf"
