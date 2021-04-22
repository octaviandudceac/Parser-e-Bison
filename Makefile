CXXFLAGS := -Wall -Wextra
LDFLAGS :=
BISONFLAGS :=

.PHONY: compile clean

run: build/python-parser
	./$< input.py

compile:
	build/python-parser

clean:
	-rm -r build

build:
	mkdir -p build

build/common.hpp: common.hpp
	cp $< $@

build/python-parser: build/python-parser.o build/python-lexer.o | build
	c++ $(LDFLAGS) -o $@ $^

build/python-parser.o: build/python-parser.cpp build/common.hpp | build
	c++ $(CXXFLAGS) -c -o $@ $<

build/python-parser.cpp: python-parser.ypp | build
	bison $(BISONFLAGS) -d -o $@ $<

build/python-lexer.cpp: python-lexer.ypp | build
	flex -o $@ $<

build/python-lexer.o: build/python-lexer.cpp build/common.hpp | build
	cc $(CFLAGS) -c -o $@ $<

