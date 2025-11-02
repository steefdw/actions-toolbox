#!/bin/bash

actionPath="$( cd "$(dirname "$0")" || exit >/dev/null 2>&1 ; pwd -P )"
readonly actionPath

repositoryPath="$PWD"
readonly repositoryPath

foo="$2"
input="$1"

echo "foo = $foo"

echo "[tools]" > ./mise.toml

echo "$input" | while IFS= read -r line; do
  [[ -z "$line" ]] && continue

  tool=$(echo "$line" | cut -d':' -f1 | xargs)
  version=$(echo "$line" | cut -d':' -f2- | xargs)
  echo "${tool} = \"${version}\"" >> ./mise.toml
done

cat ./mise.toml

[ ! -d ./mise ] \
  && mkdir mise && echo "created mise folder in ${repositoryPath}" \
  || echo "mise folder found in ${repositoryPath}"

ls -lah
ls -lah "$actionPath"/build || echo "no build folder found in ${actionPath}"

tagName='actions-toolbox:latest'
if ! docker build -t "$tagName" -f "$actionPath"/build/Dockerfile "$actionPath"
then
  echo "Docker build failed"
  exit 1
fi

docker run --rm \
  -v "${repositoryPath}/mise:/mise" \
  -v "${repositoryPath}/mise.toml:/mise.toml" \
  "$tagName" mise install