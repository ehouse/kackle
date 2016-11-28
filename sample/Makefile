DEPLOY_DIR=</destination/of/website>
WEBSERVER=<webserver.com>
SITENAME=Sample

all: build

build:
	@kackle -r "src/blog"
	@kackle -b "src"

clean:
	rm -rf $(wildcard out/*)

deploy:
	@kackle -f "out/" -n "$(SITENAME)"
	rsync -e ssh -P --delete --max-delete=100 -rvzcl "out/" $(WEBSERVER):$(DEPLOY_DIR)/$(SITENAME) --cvs-exclude

dev:
	pushd out/; python3 -m http.server 8080; popd
