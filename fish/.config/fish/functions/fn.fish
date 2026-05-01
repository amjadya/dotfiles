function fn
    set file (rg --files | fzf) && nvim "$file"
end
