#!/bin/bash

foo="$2"
input="$1"

echo "foo = $foo"

echo "[tools]" > mise.toml

echo "$input" | while IFS= read -r line; do
  [[ -z "$line" ]] && continue

  tool=$(echo "$line" | cut -d':' -f1 | xargs)
  version=$(echo "$line" | cut -d':' -f2- | xargs)
  echo "${tool} = \"${version}\"" >> mise.toml
done

[ ! -d ./mise ] && mkdir mise && echo "created mise folder" || echo "mise folder found"

docker build -t actions-tookbox -f ./build/Dockerfile .
docker run -it --rm -v ./mise:/mise -v ./mise.toml:/mise.toml actions-tookbox mise install