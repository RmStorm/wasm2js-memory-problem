# wasm2js-memory-problem
A small reproducible example of a memory issue in wasm2js. You need `Rust`, `wasm-bindgen-cli`, `wasm2js` and `node`. Start with:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# When that's done proceed to install wasm-bindgen-cli and add the wasm target:
cargo install wasm-bindgen-cli --version 0.2.92
rustup target add wasm32-unknown-unknown
```

Get `node` if you don't have it: https://nodejs.org/en/download/package-manager

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
nvm install 22 # I don't think the version here matters at all, tested on v18.17.0 and v22.11.0
```


Now you need to get wasm2js:

```bash
wget https://github.com/WebAssembly/binaryen/releases/download/version_119/binaryen-version_119-x86_64-linux.tar.gz
tar -xzf binaryen-version_119-x86_64-linux.tar.gz
cp binaryen-version_119/bin/wasm2js ~/.local/bin
```

Now everything should be ready so run:

```bash
make all
node index.js
```

The expected output is this abort:

```bash
allocating pages: 4
allocating pages: 4
allocating pages: 7
first done
allocating pages: 13
Error calling wasm function: Error: abort
    at wasm2js_trap (file:///home/rmstorm/Documents/rust/wasm2js-memory-problem/pkg/wasm2js_memory_problem_bg.wasm.js:25:33)
    at __rust_start_panic (file:///home/rmstorm/Documents/rust/wasm2js-memory-problem/pkg/wasm2js_memory_problem_bg.wasm.js:4319:3)
    at rust_panic (file:///home/rmstorm/Documents/rust/wasm2js-memory-problem/pkg/wasm2js_memory_problem_bg.wasm.js:4218:3)
    at std__panicking__rust_panic_with_hook__he5c089ac7305193e (file:///home/rmstorm/Documents/rust/wasm2js-memory-problem/pkg/wasm2js_memory_problem_bg.wasm.js:3127:5)
    at std__panicking__begin_panic_handler___7b_7bclosure_7d_7d__h010c94f3a1c5c766 (file:///home/rmstorm/Documents/rust/wasm2js-memory-problem/pkg/wasm2js_memory_problem_bg.wasm.js:3597:3)
    at std__sys__backtrace____rust_end_short_backtrace__hbe714695da4edadc (file:///home/rmstorm/Documents/rust/wasm2js-memory-problem/pkg/wasm2js_memory_problem_bg.wasm.js:4303:3)
    at rust_begin_unwind (file:///home/rmstorm/Documents/rust/wasm2js-memory-problem/pkg/wasm2js_memory_problem_bg.wasm.js:3826:3)
    at core__panicking__panic_fmt__hdc8d2d914c0710e4 (file:///home/rmstorm/Documents/rust/wasm2js-memory-problem/pkg/wasm2js_memory_problem_bg.wasm.js:3859:3)
    at core__panicking__panic__h277083fe55d571d7 (file:///home/rmstorm/Documents/rust/wasm2js-memory-problem/pkg/wasm2js_memory_problem_bg.wasm.js:3934:3)
    at __rdl_dealloc (file:///home/rmstorm/Documents/rust/wasm2js-memory-problem/pkg/wasm2js_memory_problem_bg.wasm.js:3793:3)
```

But lots of other different memory corruptions are possible when playing around a little bit!
