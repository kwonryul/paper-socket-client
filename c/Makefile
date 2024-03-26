CC=gcc
CFLAGS=-Iinclude -Iinclude/ghc -I/usr/include/python3.11
BUILD=build

$(BUILD)/paper-socket-client-c.o: src/lib.c
	mkdir -p $(BUILD)
	$(CC) -fPIC -c $(CFLAGS) $< -o $@

$(BUILD)/libpaper-socket-client-c.so: $(BUILD)/paper-socket-client-c.o
	$(CC) -fPIC -shared $^ -o $@ -pthread -L/usr/lib/x86_64-linux-gnu -lpython3.11 -ldl -lutil -lm

.PHONY: build
build:
	-rm -rf $(BUIILD)
	make $(BUILD)/libpaper-socket-client-c.so