if status is-interactive
# Commands to run in interactive sessions can go here

function fish_greeting
	echo "yo"
end

starship init fish | source
fzf --fish | source

set -x FZF_IGNORE_GLOBS --glob '!.git' --glob '!.cache' --glob '!node_modules'
set -x FZF_IGNORE_EXCLUDES --exclude '.git' --exclude '.cache' --exclude 'node_modules'
set -x FZF_ALT_C_COMMAND "fd -H --type d --follow $FZF_IGNORE_EXCLUDES --search-path '/home/meej'"
set -x FZF_ALT_C_OPTS '--no-height'

# Git abbreviations (expand visibly when you press space)
abbr -a g git
abbr -a gs git status
abbr -a ga git add
abbr -a gaa git add .
abbr -a gc git commit -m
abbr -a gp git push
abbr -a gpl git pull
abbr -a gd git diff
abbr -a gco git checkout
abbr -a gb git branch

end
