DEPLOY_DIR=/home/<user-name>/public_html
WEBSERVER=<web.server.com>
SITENAME=<sitename.com>


all: usage

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

	rsync -e ssh -P --delete -rvzcl "out/$(subst deploy-,,$@)/" $(WEBSERVER):$(DEPLOY_DIR)/$(subst deploy-,,$@) --cvs-exclude

dev-%:
	pushd out/$(subst dev-,,$@); python3 -m http.server 8080; popd

clean:
	rm -rf $(wildcard out/*)

usage:
	@echo "USAGE:"
	@echo "  make <project>         Build project folder"
	@echo "  make deploy-<project>  Deploy and build project folder"
	@echo "  make dev-<project>     Start python webserver on port 8080"
	@echo "  make new-post          Interactively create new blog post"
	@echo "  make clean             Clean out/ folder"

.PHONY: all new-post deploy clean
