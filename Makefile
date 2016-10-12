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
	@./scripts/kackle -r "$(SRC)/blog"
	# Build Blog
	@./scripts/kackle -b "$(SRC)"

deploy: $(OUT)
	# Finalize Webdir for Deployment
	@./scripts/kackle -f "$(OUT)" -n "$(SITENAME)"

	rsync -e ssh -P -rvzcl --delete $(OUT)/ $(WEBSERVER):$(DEPLOY_DIR) --cvs-exclude

clean:
	rm -rf $(wildcard out/*)

.PHONY: all new-post deploy clean
