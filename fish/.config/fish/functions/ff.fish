function ff
    set file (rg --files | fzf) && xdg-open "$file"
end
