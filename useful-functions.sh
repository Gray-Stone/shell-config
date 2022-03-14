

function GitPull {
  (
    set -vx 
    cur_head="$(git rev-parse --abbrev-ref HEAD)"
    git pull origin "${cur_head}" --ff-only "$@"
  )
}

function GitPush {
  (
    set -vx 
    cur_head="$(git rev-parse --abbrev-ref HEAD)"
    git push origin "${cur_head}" "$@"
  )
}
