function log --description 'New meej.ca logbook entry: skeleton + dev servers + nvim + browser'
    set -l site ~/Projects/meej.ca
    set -l port 4321

    # 1. pick the project — `log aero` skips the menu; bare `log` prompts
    set -l slug
    switch "$argv[1]"
        case aero aerodesign
            set slug aerodesign
        case wayless
            set slug wayless
        case rl rl-arm rl-arm-tracking
            set slug rl-arm-tracking
        case ''
            echo 'Which logbook?'
            echo '  1) aerodesign'
            echo '  2) wayless'
            echo '  3) rl-arm-tracking'
            read -l -P '> ' choice
            switch "$choice"
                case 1 aero aerodesign
                    set slug aerodesign
                case 2 wayless
                    set slug wayless
                case 3 rl rl-arm-tracking
                    set slug rl-arm-tracking
                case '*'
                    echo "log: unknown choice '$choice'" >&2
                    return 1
            end
        case '*'
            echo "log: unknown project '$argv[1]'" >&2
            return 1
    end

    # 2. file path — untitled, numbered only if today already has one
    set -l date (date +%Y-%m-%d)
    set -l dir $site/src/data/logbook/$slug
    set -l base $date-untitled
    set -l n 2
    while test -e $dir/$base.mdx
        set base $date-untitled-$n
        set n (math $n + 1)
    end
    set -l file $dir/$base.mdx

    # 3. write the skeleton
    printf '%s\n' \
        '---' \
        'title: Untitled' \
        "date: $date" \
        'summary: ""' \
        'tags: []' \
        'draft: true' \
        '---' \
        '' \
        '## What I\'m trying to achieve' \
        '' \
        '## Driving questions' \
        '' \
        '## Next' >$file
    echo "wrote $file"

    # 4. make sure astro dev is up — it owns :4321.
    #    (output.css is committed and complete; logbook prose adds no tailwind classes,
    #    so no watcher is needed. Restyling? run `pnpm dev:tw` yourself in a tab.)
    if not curl -sf -o /dev/null "http://localhost:$port/"
        env -C $site nohup pnpm dev </dev/null >/tmp/meej-dev.log 2>&1 &
        disown
        echo "started astro dev  -> /tmp/meej-dev.log"
        for i in (seq 40) # wait for it to answer before opening the browser
            curl -sf -o /dev/null "http://localhost:$port/"; and break
            sleep 0.25
        end
    end

    # 5. open the page, then drop into the editor
    xdg-open "http://localhost:$port/logbook/$slug/$base" >/dev/null 2>&1 &
    disown
    nvim $file
end
