DEPLOY_DIR=/home/<user-name>/public_html
WEBSERVER=<web.server.com>
SITENAME=<sitename.com>


all: $(OUT)

new-post:
	@./scripts/write_post.sh

%:
	# Build Blogroll index
	@./scripts/kackle -r "src/$@/blog"
	# Build Blog
	@./scripts/kackle -b "src/$@"

deploy-%:
	# Finalize Webdir for Deployment
	@./scripts/kackle -f "out/$(subst deploy-,,$@)" -n "$(SITENAME)"

	rsync -e ssh -P -rvzcl "out/$(subst deploy-,,$@)/" $(WEBSERVER):$(DEPLOY_DIR)/$(subst deploy-,,$@) --cvs-exclude

clean:
	rm -rf $(wildcard out/*)

.PHONY: all new-post deploy clean
