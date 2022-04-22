#@author Fred Brooker <git@gscloud.cz>
include .env
all: info

info:
	@echo "\e[1;32m👾 Welcome to ${APP_NAME}"
	@echo ""
	@echo "🆘 \e[0;1mmake clean\e[0m - clean current folder"
	@echo "🆘 \e[0;1mmake build\e[0m - build blocklist"
	@echo "🆘 \e[0;1mmake push\e[0m - push to GitHub"
	@echo "🆘 \e[0;1mmake docs\e[0m - build documentation"

docs:
	@bash ./bin/create_pdf.sh

build:
	@bash ./bin/build.sh

clean:
	@rm -f *.txt *.gz

push:
	@bash ./bin/push.sh

everything: clean docs build push
