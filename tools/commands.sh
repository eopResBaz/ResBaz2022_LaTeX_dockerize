function create() { docker run --rm -v $(pwd):/results notebook2022:latest "$@"; }
