all: info

info:
	@echo "\e[1;32m👾 Welcome to P2P blocklist builder 👾\n"

	@echo "🆘 \e[0;1mmake build\e[0m - build blocklist"
	@echo "🆘 \e[0;1mmake clean\e[0m - clean current folder"
	@echo "🆘 \e[0;1mmake docs\e[0m - build documentation"

docs:
	@bash ./bin/create_pdf.sh

build:
	@bash ./bin/build.sh

clean:
	@rm -f *.txt *.gz

everything: clean docs build
