PROJECT=sample
DEPLOY_DIR=/PATH/TO/SOME/FOLDER
WEBSERVER=www.sample.io
SITENAME=sample.io

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
	# Compress CSS, HTML and JS of out/personal-site
	find -L out/personal-site \( -name "*.html" -or -name "*.css" \) -exec htmlcompressor --compress-js --compress-css {} -o {} \;

$(PROJECT)-deploy: $(PROJECT)
	rsync -e ssh -P -rvzcl --delete out/$(PROJECT)/ $(WEBSERVER):$(DEPLOY_DIR) --cvs-exclude

clean:
	rm -rf $(wildcard out/*)

.PHONY: all new-post $(PROJECT) $(PROJECT)-deploy personal-site personal-site-prod personal-site-deploy clean
