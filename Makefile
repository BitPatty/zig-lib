SRC := src/lib.zig
OUT_DIR := build
ZIG_FLAGS := -O ReleaseSmall
TARGETS := x86_64.a x86_64_mingw.a x86_64_msvc.lib wasm32.wasm

all: $(addprefix $(OUT_DIR)/lib_, $(TARGETS))

$(OUT_DIR)/lib_x86_64.a: $(SRC)
	mkdir -p $(OUT_DIR)
	./zig build-lib $(SRC) -target x86_64-freestanding $(ZIG_FLAGS) -femit-asm=$@.asm -femit-bin=$@

$(OUT_DIR)/lib_x86_64_mingw.a: $(SRC)
	mkdir -p $(OUT_DIR)
	./zig build-lib $(SRC) -target x86_64-windows-gnu $(ZIG_FLAGS) -femit-asm=$@.asm -femit-bin=$@

$(OUT_DIR)/lib_x86_64_msvc.lib: $(SRC)
	mkdir -p $(OUT_DIR)
	./zig build-lib $(SRC) -target x86_64-windows-msvc $(ZIG_FLAGS) -femit-asm=$@.asm -femit-bin=$@

# Note that build-exe is required for wasm: https://github.com/ziglang/zig/pull/17815
$(OUT_DIR)/lib_wasm32.wasm: $(SRC)
	mkdir -p $(OUT_DIR)
	./zig build-exe $(SRC) -target wasm32-freestanding $(ZIG_FLAGS) -rdynamic -fno-entry -femit-bin=$@
	wasm2wat $@ > $@.wat

clean:
	@echo "Cleaning $(OUT_DIR)..."
	rm -rf $(OUT_DIR)
	@echo "Clean complete."

.PHONY: all clean
