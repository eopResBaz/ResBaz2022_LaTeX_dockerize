function create() { docker run --rm -v $(pwd):/results ghcr.io/eirianop/dockerresbaz2022:latest "$@"; }
