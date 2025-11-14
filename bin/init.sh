#!/usr/bin/env bash
set -e

echo "[*] Performing system autopsy…"

# -------------------------
# WSL CHECK
# -------------------------
if grep -qi "microsoft" /proc/version 2>/dev/null; then
    echo "[!] Warning: You're in WSL. Filesystem behaves like a drunk goat."
    echo "[!] Things WILL work, but expect weirdness with Docker + binds."
fi

# -------------------------
# OS DETECTION
# -------------------------
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ -f /etc/debian_version ]]; then
    OS="debian"
else
    echo "[-] Unsupported OS. This script doesn’t babysit exotic snowflake distros."
    exit 1
fi

echo "[*] Detected OS: $OS"

# -------------------------
# PACKAGE MANAGER FUNCS
# -------------------------

install_macos() {
    # Homebrew ------------------------------------------------
    if ! command -v brew >/dev/null 2>&1; then
        echo "[!] Homebrew missing. Install it with:"
        echo '    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        exit 1
    fi

    # makeself ----------------------------------------------
    if ! command -v makeself >/dev/null 2>&1; then
        echo "[*] Installing makeself via brew…"
        brew install makeself
    fi

    # git ----------------------------------------------------
    if ! command -v git >/dev/null 2>&1; then
        echo "[*] Installing git via brew…"
        brew install git
    fi

    # ruby ---------------------------------------------------
    if ! command -v ruby >/dev/null 2>&1; then
        echo "[*] Installing ruby via brew…"
        brew install ruby
    fi

    # bundler -----------------------------------------------
    if ! command -v bundle >/dev/null 2>&1; then
        echo "[*] Installing bundler…"
        gem install bundler
    fi
}

install_debian() {
    # Update --------------------------------------------------
    echo "[*] Updating apt…"
    sudo apt update -y

    # makeself -----------------------------------------------
    if ! command -v makeself >/dev/null 2>&1; then
        echo "[*] Installing makeself…"
        sudo apt install -y makeself
    fi

    # git -----------------------------------------------------
    if ! command -v git >/dev/null 2>&1; then
        echo "[*] Installing git…"
        sudo apt install -y git
    fi

    # ruby ----------------------------------------------------
    if ! command -v ruby >/dev/null 2>&1; then
        echo "[*] Installing ruby-full…"
        sudo apt install -y ruby-full
    fi

    # bundler ------------------------------------------------
    if ! command -v bundle >/dev/null 2>&1; then
        echo "[*] Installing bundler…"
        sudo gem install bundler
    fi
}

# -------------------------
# EXECUTE INSTALLERS
# -------------------------

case "$OS" in
    macos)
        install_macos
        ;;
    debian)
        install_debian
        ;;
esac

echo "[✓] All dependencies installed. This machine is now tamed and obedient."
echo "[✓] You may now build the .run package or summon the Dockermancer."

