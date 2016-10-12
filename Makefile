SRC=src/sample
OUT=out/sample
DEPLOY_DIR=/home/<user-name>/public_html/
WEBSERVER=<web-server>
SITENAME=<site-name>

all: $(OUT)

new-post:
	@./scripts/write_post.sh

$(OUT): $(SRC)
	# Build Blogroll index
	@./scripts/kackle -r $(SRC)/blog
	# Build Blog
	@./scripts/kackle -b $(SRC)
	# Create sitemap
	@./scripts/kackle -s $(OUT) -n "$(SITENAME)"
	# Compress the CSS, HTML and JS
	find -L $(OUT) \( -name "*.html" -or -name "*.css" \) -exec htmlcompressor --compress-js --compress-css {} -o {} \;

deploy: $(OUT)
	rsync -e ssh -P -rvzcl --delete $(OUT)/ $(WEBSERVER):$(DEPLOY_DIR) --cvs-exclude

clean:
	rm -rf $(wildcard out/*)

.PHONY: all new-post deploy clean
