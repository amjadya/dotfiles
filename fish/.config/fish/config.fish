if status is-interactive
# Commands to run in interactive sessions can go here

function fish_greeting
	echo "yo"
end

starship init fish | source

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
