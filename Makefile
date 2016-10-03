WEBDIR = /home/ehouse/public_html/
TEST_WEBDIR = /home/ehouse/public_html/webtest/
WEBSERVER = bawls.ehouse.io
SITENAME = ehouse.io

all: test-build

new-post:
	@./scripts/write_post.sh

test-build:
	@./scripts/local.sh
	@./scripts/kackle -t build src/personal-site/theme/base.html src/personal-site
	@./scripts/kackle sitemap out/personal-site $(SITENAME)

build:
	@./scripts/local.sh
	@./scripts/kackle -t build src/personal-site/theme/base.html src/personal-site
	@./scripts/kackle sitemap out/personal-site $(SITENAME)

	find out \( -name "*.html" -or -name "*.css" \) -exec htmlcompressor --compress-js --compress-css {} -o {} \;
	find out \( -name "*.html" -or -name "*.css" \) -exec gzip {} \;

deploy: clean build
	rsync -e ssh -P -rvzc --delete out/ $(WEBSERVER):$(WEBDIR) --cvs-exclude

test-deploy: clean test-build
	rsync -e ssh -P -rvzc --delete out/ $(WEBSERVER):$(TEST_WEBDIR) --cvs-exclude

devserver:
	pushd out/personal-site/; python -m SimpleHTTPServer 8000; popd

clean:
	rm -rf $(wildcard out/*)

.PHONY: all new-post standalone test-build build deploy test-deploy devserver clean
