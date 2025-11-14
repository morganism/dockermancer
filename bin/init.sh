#!/usr/bin/env bash
set -e

echo "[*] Inspecting system sanity…"

# WSL warning
if grep -qi "microsoft" /proc/version 2>/dev/null; then
    echo "[!] WSL detected. Expect Docker to behave like a hungover donkey."
fi

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ -f /etc/debian_version ]]; then
    OS="debian"
else
    echo "[-] Unsupported OS. You're on your own, warlock."
    exit 1
fi

echo "[*] OS: $OS"

install_macos() {
    # brew
    if ! command -v brew >/dev/null 2>&1; then
        echo "[!] Missing brew. Install manually:"
        echo '    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        exit 1
    fi

    # makeself
    if ! command -v makeself >/dev/null 2>&1; then
        echo "[*] Installing makeself…"
        brew install makeself
    fi

    # git
    if ! command -v git >/dev/null 2>&1; then
        echo "[*] Installing git…"
        brew install git
    fi
}

install_debian() {
    sudo apt update -y

    # makeself
    if ! command -v makeself >/dev/null 2>&1; then
        echo "[*] Installing makeself…"
        sudo apt install -y makeself
    fi

    # git
    if ! command -v git >/dev/null 2>&1; then
        echo "[*] Installing git…"
        sudo apt install -y git
    fi
}

case "$OS" in
    macos) install_macos ;;
    debian) install_debian ;;
esac

echo "[✓] Env looks good. Go summon your .run file."
