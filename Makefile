PROJECT=blog
DEPLOY_DIR=/home/ehouse/public_html/webtest
WEBSERVER=bawls.ehouse.io
SITENAME=ehouse.io

all: $(PROJECT)

new-post:
	@./scripts/write_post.sh

$(PROJECT):
	# Build Blogroll index
	@./scripts/kackle -r src/$(PROJECT)/blog
	# Build Blog
	@./scripts/kackle -b src/$(PROJECT)
	# Create sitemap
	@./scripts/kackle -s out/$(PROJECT) -n "$(SITENAME)"
	# Compress the CSS, HTML and JS
	find -L out/$(PROJECT) \( -name "*.html" -or -name "*.css" \) -exec htmlcompressor --compress-js --compress-css {} -o {} \;

deploy: $(PROJECT)
	rsync -e ssh -P -rvzcl --delete out/$(PROJECT)/ $(WEBSERVER):$(DEPLOY_DIR) --cvs-exclude

clean:
	rm -rf $(wildcard out/*)

.PHONY: all new-post $(PROJECT) deploy clean
