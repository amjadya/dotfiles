function fn --description "fuzzy-find a file and open it in nvim"
    set -l search_path .
    if test (count $argv) -gt 0
        set search_path $argv
    end

    for p in $search_path
        if not test -e $p
            echo "fn: '$p' does not exist"
            return 1
        end
    end

    set -l file (
        rg --files --hidden --glob '!.git' --glob '!.cache' --glob '!node_modules' -- $search_path |
        fzf
    )

    if test -n "$file"
        nvim $file
    end
end
