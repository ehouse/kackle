WEBDIR = /home/ehouse/public_html/
TEST_WEBDIR = /home/ehouse/public_html/webtest/
WEBSERVER = bawls.ehouse.io

MD_FILES := $(shell find src -name "*.md")
HTML_BLD := $(patsubst src/%.md, out/%.html, $(MD_FILES))

all: test-build

new-post:
	@./scripts/write_post.sh

test-build: $(HTML_BLD)
	cp -r $(wildcard static/*) out/
	cp -r license.txt out/

build: $(HTML_BLD)
	./scripts/local.sh
	cp -r $(wildcard static/*) out/
	cp -r license.txt out/
	find out -name "*.html" -or -name "*.css" -exec htmlcompressor --compress-js --compress-css {} -o {} \;

out/%.html: src/%.md Makefile
	@mkdir -p $(dir $@)
	pandoc --template theme/templates/base.html $< -o $@

deploy: build
	rsync -e ssh -P -rvzc --delete out/ $(WEBSERVER):$(WEBDIR) --cvs-exclude

test-deploy: test-build
	rsync -e ssh -P -rvzc --delete out/ $(WEBSERVER):$(TEST_WEBDIR) --cvs-exclude

devserver: all
	pushd out/; python -m SimpleHTTPServer 8000; popd

clean:
	rm -rf $(wildcard out/*)

.PHONY: all deploy test-deploy clean test-build build new-post
