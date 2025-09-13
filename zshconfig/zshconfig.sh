install_packages() {
  if command -v apt-get > /dev/null 2>&1; then
    sudo apt-get install -y $1
  elif command -v yum > /dev/null 2>&1; then
    sudo yum install -y $1
  elif command -v pacman > /dev/null 2>&1; then
    sudo pacman -S $1 --noconfirm
  elif command -v dnf > /dev/null 2>&1; then
    sudo dnf install -y $1
  else
    echo "Could not find a package manager to install packages with."
    exit 1
  fi

  if [ $? -ne 0 ]; then
    echo "Failed to install $1"
    exit 1
  fi
}

for pkg in zsh git curl zoxide; do
  if ! command -v $pkg > /dev/null 2>&1; then
    echo "$pkg is not installed. Installing $pkg..."
    install_packages $pkg
  fi
done



declare -A plugins=(
  ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
  ["fast-syntax-highlighting"]="https://github.com/zdharma-continuum/fast-syntax-highlighting"
  ["zsh-autocomplete"]="https://github.com/marlonrichert/zsh-autocomplete.git --depth=1"
)

for plugin in "${!plugins[@]}"; do
  if [ ! -d ~/.zsh/plugins/$plugin ]; then
    echo "Installing $plugin..."
    git clone ${plugins[$plugin]} ~/.oh-my-zsh/custom/plugins/$plugin
  else
    echo "$plugin is already installed"
  fi
done

if [ -f ~/.zshrc ]; then
  echo "Backing up existing .zshrc..."
  mv ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
fi

cp ./.zshrc ~/.zshrc

echo "Setup completed successfully!"

