# Makefile

# Variables
TARGET = wasm32-unknown-unknown
CRATE_NAME = wasm2js_memory_problem
BUILD_DIR = target/$(TARGET)/release
WASM = $(BUILD_DIR)/$(CRATE_NAME).wasm
PKG_DIR = pkg
BINDGEN_TARGET = bundler
WASM2JS_INPUT = $(PKG_DIR)/$(CRATE_NAME)_bg.wasm
WASM2JS_OUTPUT = $(WASM2JS_INPUT).js
JS_FILE = $(PKG_DIR)/$(CRATE_NAME).js
SRC = $(wildcard src/*.rs)

# Default target
all: $(WASM) bindgen wasm2js sed_modify

# Step 1: Build the Rust project targeting wasm32-unknown-unknown
$(WASM): $(SRC) Cargo.toml
	cargo build --release --lib --target $(TARGET)

# Step 2: Run wasm-bindgen
bindgen: $(WASM)
	wasm-bindgen $(WASM) --target $(BINDGEN_TARGET) --out-dir $(PKG_DIR)

# Step 3: Convert the .wasm file to JavaScript using wasm2js
wasm2js: $(WASM2JS_INPUT)
	wasm2js $(WASM2JS_INPUT) -o $(WASM2JS_OUTPUT)

# Step 4: Modify the output JavaScript files using sed, from: https://rustwasm.github.io/docs/wasm-bindgen/examples/wasm2js.html
sed_modify: $(JS_FILE) $(WASM2JS_OUTPUT)
	sed -i 's/$(CRATE_NAME)_bg\.wasm/$(CRATE_NAME)_bg.wasm.js/' $(JS_FILE)
	# This one just adds a little console.log() to the memory grow function!
	sed -i '/function __wasm_memory_grow(pagesToAdd) {/a\  console.log("allocating pages:", pagesToAdd);' $(WASM2JS_OUTPUT)

# Clean build artifacts
clean:
	cargo clean
	rm -rf $(PKG_DIR)

# Phony targets
.PHONY: all bindgen wasm2js sed_modify clean
