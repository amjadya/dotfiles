function days
    if test (count $argv) -eq 1; and string match -q -r '^[+-]?[0-9]+$' -- $argv[1]
        date -d "$argv[1] days" +"%B %-d %Y" 2>/dev/null
        return
    end

    set -l target_string (string join ' ' -- $argv)
    set -l target_date (date -d "$target_string" +%F 2>/dev/null)

    if test -z "$target_date"
        echo "Invalid date format."
        return 1
    end

    set -l today_date (date +%F)

    # Convert both dates to UTC midnight so DST doesn't affect the result
    set -l target_midnight (date -u -d "$target_date" +%s)
    set -l today_midnight (date -u -d "$today_date" +%s)

    math "($target_midnight - $today_midnight) / 86400"
end