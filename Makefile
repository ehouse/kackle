WEBDIR = /home/ehouse/public_html/
TEST_WEBDIR = /home/ehouse/public_html/webtest/
WEBSERVER = bawls.ehouse.io
SITENAME = ehouse.io
PROJECTS := $(patsubst src/%, %, $(wildcard src/*))

all: $(PROJECTS)

new-post:
	@./scripts/write_post.sh

$(PROJECTS):
	@./scripts/kackle -t build src/$@/theme/base.html src/$@
	@./scripts/kackle sitemap out/$@ $(SITENAME)

test-build:
	@./scripts/prebuild.sh
	@./scripts/kackle -t build src/personal-site/theme/base.html src/personal-site
	@./scripts/kackle sitemap out/personal-site $(SITENAME)
	@./scripts/postbuild.sh

build:
	@./scripts/prebuild.sh
	@./scripts/kackle build src/personal-site/theme/base.html src/personal-site
	@./scripts/kackle sitemap out/personal-site $(SITENAME)
	@./scripts/postbuild.sh

	find -L out \( -name "*.html" -or -name "*.css" \) -exec htmlcompressor --compress-js --compress-css {} -o {} \;

deploy: clean build
	rsync -e ssh -P -rvzcl --delete out/personal-site/ $(WEBSERVER):$(WEBDIR) --cvs-exclude

test-deploy:
	rsync -e ssh -P -rvzcl --delete out/personal-site/ $(WEBSERVER):$(TEST_WEBDIR) --cvs-exclude

clean:
	rm -rf $(wildcard out/*)

.PHONY: all new-post $(PROJECTS) test-build build deploy test-deploy clean
