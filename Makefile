build: bin/kackle

.PHONY: build

bin/kackle: $(wildcard src/*.sh) $(wildcard src/lib/*.sh)
	@mkdir -p bin
	./build.sh kackle.sh
	@chmod +x bin/kackle

test:
	$(shell cd src; shellcheck -x *.sh > ../shellcheck.txt)
#$(shell cd src; shellcheck -x *.sh | tee ../shellcheck.txt >/dev/null)
	@echo "Writing results of shellcheck to [./shellcheck.txt]"
	@echo
	@echo "Creating webserver at https://localhost:8080"
	@echo "Exit webserver with <ctr-c>"
	@echo
	cd skel && make clean && make publish && make dev

.PHONY: test

install: bin/kackle
	mkdir -p $(HOME)/bin
	cp bin/kackle $(HOME)/bin

.PHONY: install

uninstall:
	rm $(HOME)/bin/kackle

.PHONY: uninstall

clean:
	rm -f $(wildcard bin/*)

.PHONY: clean
