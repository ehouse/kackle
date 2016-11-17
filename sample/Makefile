DEPLOY_DIR=</destination/of/website>
WEBSERVER=<webserver.com>
SITENAME=Sample

all: build

build:
	# Build Blogroll index
	@kackle -r "src/blog"
	# Build Blog
	@kackle -b "src"

clean:
	rm -rf $(wildcard out/*)

deploy:
	# Finalize Webdir for Deployment
	@kackle -f "out/" -n "$(SITENAME)"

	rsync -e ssh -P --delete --max-delete=100 -rvzcl "out/" $(WEBSERVER):$(DEPLOY_DIR)/$(SITENAME) --cvs-exclude

dev:
	pushd out/; python3 -m http.server 8080; popd
