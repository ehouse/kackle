build: bin/kackle

.PHONY: build

bin/kackle: $(wildcard src/*.sh) $(wildcard src/lib/*.sh)
	@mkdir -p bin
	./build.sh kackle.sh
	@chmod +x bin/kackle

test:
	shellcheck -x $(wildcard src/*.sh)

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
