build: bin/kackle

.PHONY: build

bin/kackle: $(wildcard src/*.sh)
	mkdir -p bin
	cp src/kackle.sh bin/kackle
	chmod +x bin/kackle

test:
	shellcheck $(wildcard src/*.sh)

.PHONY: test

install: bin/kackle
	mkdir -p $(HOME)/bin
	cp bin/kackle $(HOME)/bin

.PHONY: install

clean:
	rm -f $(wildcard bin/*)

.PHONY: clean
