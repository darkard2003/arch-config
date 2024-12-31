# Dark Config Setup

This repository contains configuration files for various applications and a script to set them up.

## Applications

The following applications are configured by this script:

- ghostty
- kanata
- kitty
- nvim
- sway
- swaylock
- swaync
- waybar

## Setup Script

The `strap.sh` script creates symbolic links from the configuration files in this repository to the appropriate locations in your home directory.

### Usage

1. Clone this repository to your local machine:

    ```bash
    git clone <repository-url>
    cd <repository-directory>
    ```

2. Make the script executable:

    ```bash
    chmod +x strap.sh
    ```

3. Run the script:

    ```bash
    ./strap.sh
    ```

### How It Works

The script performs the following steps for each application listed in the `CONFIGS` array:

1. Checks if the configuration directory exists in `~/.config/`.
2. If it exists and is not a symlink, it creates a backup with a `.bak` extension.
3. If it is a symlink, it removes the existing symlink.
4. Creates a new symlink from the repository's configuration directory to `~/.config/`.

### Notes

- Ensure you have the necessary permissions to create and modify files in your home directory.
- Backup any existing configuration files before running the script to avoid accidental data loss.
- For GTK icons and theme, consider installing:
  - [Catppuccin Icon Theme](https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme.git)
  - [Catppuccin Cursor Theme](https://github.com/catppuccin/cursors.git)

### License

This project is licensed under the MIT License.
