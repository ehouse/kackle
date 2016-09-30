WEBDIR = /home/ehouse/public_html/
TEST_WEBDIR = /home/ehouse/public_html/webtest/
WEBSERVER = bawls.ehouse.io
SITENAME = ehouse.io

MD_FILES := $(shell find src -name "*.md")
HTML_BLD := $(patsubst src/%.md, out/%.html, $(MD_FILES))

all: test-build

new-post:
	@./scripts/write_post.sh

test-build: $(HTML_BLD) out/sitemap.xml
	./scripts/local.sh
	cp -r static/css static/img out/
	cp static/robots-test.txt out/robots.txt
	cp -r license.txt out/

build: $(HTML_BLD) out/sitemap.xml
	./scripts/local.sh
	cp -r static/css static/img out/
	cp static/robots-prod.txt out/robots.txt
	cp -r license.txt out/
	find out \( -name "*.html" -or -name "*.css" \) -exec htmlcompressor --compress-js --compress-css {} -o {} \;
	find out \( -name "*.html" -or -name "*.css" \) -exec gzip {} \;

deploy: clean build
	rsync -e ssh -P -rvzc --delete out/ $(WEBSERVER):$(WEBDIR) --cvs-exclude

test-deploy: clean test-build
	rsync -e ssh -P -rvzc --delete out/ $(WEBSERVER):$(TEST_WEBDIR) --cvs-exclude

devserver: all
	pushd out/; python -m SimpleHTTPServer 8000; popd

clean:
	rm -rf $(wildcard out/*)

out/%.html: src/%.md Makefile
	@mkdir -p $(dir $@)
	pandoc --template theme/templates/base.html $< -o $@

out/sitemap.xml: Makefile
	./scripts/sitemap.sh $(SITENAME) > out/sitemap.xml

.PHONY: all new-post standalone test-build build deploy test-deploy devserver clean
