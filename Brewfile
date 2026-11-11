# == CFG =====
cask_args appdir: "/Applications"
# == CLI =====
brew "autoconf"
brew "automake"
brew "awk"
brew "binutils"
brew "bison"
brew "brotli"
# Bottled. `cargo install --locked cargo-update` fails to build against Homebrew's OpenSSL 4.
brew "cargo-update"
brew "cmake"
brew "coreutils"
brew "cpanminus"
brew "dockutil" if OS.mac?
brew "fzf", link: true
brew "gcc"
brew "gdbm"
brew "gettext"
brew "git", link: true
brew "gh", link: true
brew "glibc" if OS.linux?
brew "gnu-indent"
brew "gnu-sed"
brew "gnu-tar"
brew "gnu-which"
brew "gnupg" if OS.mac?
brew "go"
brew "grep"
brew "gzip"
brew "jq"
brew "lua"
brew "luarocks"
brew "m4"
brew "make"
brew "neovim", args: ["build-from-source", "HEAD"], link: true
# brew bundle runs npm with only $HOMEBREW_PREFIX/opt/node/bin added to its stripped PATH, so
# the npm entries need the node formula. Keep it unlinked: node@24 provides `node` on PATH.
brew "node", link: false
# :overwrite links the keg-only node@24 with --force --overwrite; bundle ignores :force.
brew "node@24", link: :overwrite
# Reattaches to the GUI session so pam_tid.so can prompt for Touch ID inside tmux
brew "pam-reattach" if OS.mac?
brew "python3", link: true
brew "ripgrep-all"
brew "rust", link: :overwrite
brew "stow", link: true
brew "texinfo"
brew "tmux", link: true
brew "tree-sitter-cli", link: true
brew "unzip"
brew "uv"
brew "watch"
brew "wget"
brew "zsh", link: true
# == GUI ===== (Homebrew Cask is macOS-only)
if OS.mac?
  cask "safari-technology-preview", greedy: true
  cask "qlmarkdown"
end
cask "claude-code"
cask "docker-desktop"
cask "font-blex-mono-nerd-font"
cask "font-server-mono"
cask "wezterm@nightly"
# == MISC =====
go "github.com/noperator/sol/cmd/sol"
go "mvdan.cc/sh/v3/cmd/shfmt"
npm "@augmentcode/auggie"
npm "@laboratoria/mdlint"
npm "@openai/codex"
npm "@openapitools/openapi-generator-cli"
npm "@redocly/cli"
npm "@stoplight/spectral-cli"
npm "ccusage"
npm "htmlhint"
npm "httpyac"
npm "js-yaml"
npm "jshint"
npm "jsonlint"
npm "markdownlint"
npm "markdownlint-cli2"
npm "netlify-cli"
npm "renovate"
npm "tslint"
uv "beautysh"
uv "mdformat", with: ["mdformat-gfm"]
uv "pynvim"
uv "typer"
cargo "bat"
