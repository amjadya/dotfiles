function s --description "search file contents, pick a match, open in nvim"
    if test (count $argv) -eq 0
        echo "Usage: s <pattern> [path]"
        return 1
    end

    set -l pattern $argv[1]
    set -l search_path .
    if test (count $argv) -gt 1
        set search_path $argv[2..-1]
    end

    for p in $search_path
        if not test -e $p
            echo "s: '$p' does not exist (gotta quote mult-word patterns)"
            return 1
        end
    end

    set -l selected (
        rg --line-number --no-heading --smart-case --hidden \
           --glob '!.git' --glob '!.cache' --glob '!node_modules' \
           -- "$pattern" $search_path |
        fzf --delimiter ':' \
            --preview 'bat --color=always --highlight-line {2} --style=numbers {1}' \
            --preview-window 'right:60%:+{2}+3/2'
    )

    if test -n "$selected"
        set -l parts (string split --max 2 ':' -- $selected)
        nvim $parts[1] +$parts[2]
    end
end
