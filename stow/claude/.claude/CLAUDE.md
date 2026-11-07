# Global instructions

## Environment
- Linux on WSL2, zsh, tmux, Neovim (LazyVim)
- Dotfiles managed with GNU stow from ~/projects/dotfiles

## Preferences
- Never commit, amend or push: I always handle commits myself. Don't offer to commit either;
  just leave the changes in the working tree (a suggested commit message is fine)
- Commit messages: conventional prefix (`feat:`, `fix:`, `conf:`), short lowercase summary
- Never commit secrets (keys, tokens, `.credentials.json`, `.env`)

## Code comments addressed to Claude
- `REVIEW:` and `ASK:` comments in code are notes from me to you (highlighted in nvim via todo-comments)
- `ASK:` is a question: answer it in your reply
- `REVIEW:` asks you to review the code it points at and give feedback or suggested changes
- When working in a file or repo, look for these (e.g. `rg -n '\b(ASK|REVIEW):'`) and address each one;
  don't delete them yourself unless I ask, I remove them once handled
