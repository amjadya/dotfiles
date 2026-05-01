function gacp --description "git add all, commit with message, push"
    if test (count $argv) -eq 0
        echo "Usage: gacp <commit message>"
        return 1
    end
    git add . && git commit -m "$argv" && git push
end
