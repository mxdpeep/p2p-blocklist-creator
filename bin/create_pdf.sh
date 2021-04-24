#!/bin/bash

command -v docker >/dev/null 2>&1 || { echo "Docker is NOT installed!"; exit;}

find . -type f -iname "*.md" -exec echo "{}" \; -exec docker run --rm -v "$(pwd)":/data pandoc/core -f markdown -t asciidoc -i {} -o "{}.adoc" \;
find . -type f -iname "*.adoc" -exec echo "{}" \; -exec docker run --rm -v $(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf -a allow-uri-read -d book "{}" \;
