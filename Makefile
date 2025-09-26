#@author Fred Brooker <git@gscloud.cz>
include .env

all: info
info:
	@echo "\e[1;32m👾 Welcome to ${APP_NAME}"
	@echo ""
	@echo "\e[0;1mclean\e[0m - clean folder"
	@echo "\e[0;1mbuild\e[0m - build blocklist"
	@echo "\e[0;1mpush\e[0m - push to GitHub"
	@echo "\e[0;1mdocs\e[0m - build documentation"
	@echo ""

docs:
	@find . -maxdepth 1 -iname "*.md" -exec echo "converting {} to ADOC" \; -exec docker run --rm -v "$$(pwd)":/data pandoc/core -f markdown -t asciidoc -i "{}" -o "{}.adoc" \;
	@find . -maxdepth 1 -iname "*.adoc" -exec echo "converting {} to PDF" \; -exec docker run --rm -v $$(pwd):/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf -a allow-uri-read -d book "{}" \;
	@find . -maxdepth 1 -iname "*.adoc" -delete

build:
	@bash ./bin/build.sh

clean:
	@rm -f *.txt *.gz

push:
	@bash ./bin/push.sh

# macro
everything: clean build push
