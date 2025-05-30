TEMP_DIR="./temp"

if [ ! -d "$TEMP_DIR" ]; then
    mkdir $TEMP_DIR
fi

THEME_NAME="where-is-my-sddm-theme"
THEME_URL="https://github.com/stepanzubkov/where-is-my-sddm-theme.git"
CATPPUCCIN_THEME_NAME="where-is-my-sddm-theme-catppuccin"
CATPPUCCIN_THEME_URL="https://github.com/catppuccin/where-is-my-sddm-theme.git"
SDDM_THEME_DIR="/usr/share/sddm/themes"

[ -d "$TEMP_DIR/$CATPPUCCIN_THEME_NAME" ] || git clone "$CATPPUCCIN_THEME_URL" "$TEMP_DIR/$CATPPUCCIN_THEME_NAME"
[ -d "$TEMP_DIR/$THEME_NAME" ] || git clone "$THEME_URL" "$TEMP_DIR/$THEME_NAME"

theme_file="$TEMP_DIR/$THEME_NAME/where_is_my_sddm_theme/theme.conf"
catppuccin_file="$TEMP_DIR/$CATPPUCCIN_THEME_NAME/themes/catppuccin-mocha.conf"

update_theme_value() {
    local key="$1"
    local value="$2"
    sed -i "s/\($key=\).*/\1$value/" "$theme_file"
}

while IFS='=' read -r key value; do
    key=$(echo "$key" | tr -d '[:space:]')
    if grep -q "^$key=" "$theme_file"; then
        update_theme_value "$key" "$value"
    fi
done < "$catppuccin_file"

sudo -v
[ -d "$SDDM_THEME_DIR/$THEME_NAME" ] || sudo mkdir -p "$SDDM_THEME_DIR/$THEME_NAME"
sudo cp "$TEMP_DIR/$THEME_NAME/where_is_my_sddm_theme/"  "$SDDM_THEME_DIR/$THEME_NAME" -r


