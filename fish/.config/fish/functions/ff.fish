function ff --description "fuzzy-find a file and open it in your default app"
    set -l search_path .
    if test (count $argv) -gt 0
        set search_path $argv
    end

    for p in $search_path
        if not test -e $p
            echo "ff: '$p' does not exist"
            return 1
        end
    end

    set -l file (
        rg --files --hidden $FZF_IGNORE_GLOBS -- $search_path |
        fzf
    )

    if test -n "$file"
        xdg-open $file &
        disown
    end
end
