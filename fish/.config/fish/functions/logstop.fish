function logstop --description 'Stop the meej.ca dev server started by `log`'
    set -l port 4321

    # astro owns :4321 — find the pid(s) listening there
    set -l pids (ss -ltnp "sport = :$port" 2>/dev/null | string match -rg 'pid=(\d+)')

    if test (count $pids) -gt 0
        kill $pids 2>/dev/null
        pkill -f 'pnpm dev' # the wrapper that spawned it
        echo "stopped astro dev (pid $pids)"
    else
        echo 'nothing was running'
    end
end
