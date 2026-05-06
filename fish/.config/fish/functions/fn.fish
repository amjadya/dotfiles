function fn --description "fuzzy-find a file and open it in nvim"
    argparse 'a/all' -- $argv
    or return

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

    set -l rg_args --files --hidden $FZF_IGNORE_GLOBS
    if set -q _flag_all
        set -a rg_args --no-ignore
    end

    set -l file (
        rg $rg_args -- $search_path |
        fzf
    )

    if test -n "$file"
        nvim $file
    end
end
