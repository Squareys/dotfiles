#!/usr/bin/env bash
# Install this repo's (modern, Lua/lazy.nvim) Neovim config.
# Linux is the primary target; the macOS font step is kept.
# Idempotent. Run:  ./install_nvim.sh
set -euo pipefail
DOT="$(cd "$(dirname "$0")" && pwd)"

# 1) Point ~/.config/nvim at this repo's nvim/ (symlink; back up anything real).
CFG="$HOME/.config/nvim"
mkdir -p "$HOME/.config"
if [ -L "$CFG" ]; then
  rm -f "$CFG"
elif [ -e "$CFG" ]; then
  mv "$CFG" "$CFG.bak.$(date +%s)"
  echo "backed up existing ~/.config/nvim"
fi
ln -s "$DOT/nvim" "$CFG"
echo "linked ~/.config/nvim -> $DOT/nvim"

# 2) Powerline-patched font -> user font dir.
FONT="$DOT/consolas-powerline-vim/CONSOLA-Powerline.ttf"
if [ -f "$FONT" ]; then
  case "$(uname -s)" in
    Darwin) mkdir -p "$HOME/Library/Fonts"; cp "$FONT" "$HOME/Library/Fonts/";;
    *)      mkdir -p "$HOME/.local/share/fonts"; cp "$FONT" "$HOME/.local/share/fonts/"; command -v fc-cache >/dev/null && fc-cache -f >/dev/null 2>&1 || true;;
  esac
  echo "installed Powerline font"
fi

# 3) Install/sync plugins headless (lazy.nvim self-bootstraps on first run).
echo "syncing plugins (headless)…"
nvim --headless "+Lazy! sync" +qa 2>/dev/null || echo "  (open nvim and run :Lazy sync if this skipped)"

echo
echo "done. Launch: nvim"
echo "On first real file open, mason installs the LSP servers (clangd, ts_ls, cssls,"
echo "jsonls, eslint) and tree-sitter compiles parsers — needs a C compiler, and"
echo "node/npm for the web servers."
