
(
  cd "$(dirname "$0")"
  docker build -t coding-agent .
)

docker run -it --rm -v .:/workspace coding-agent
