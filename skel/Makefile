SITENAME=Sample

all: build

build:
	@kackle -r "src/blog"
	@kackle -b "src"

.PHONY: build


publish: build
	@kackle -f "out/" -N "$(SITENAME)"

.PHONY: publish

clean:
	rm -rf $(wildcard out/*)

.PHONY: clean

dev:
	pushd out/; python3 -m http.server 8080; popd

.PHONY: dev
