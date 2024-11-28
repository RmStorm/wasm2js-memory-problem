// index.js

// Import the wasm-bindgen generated JS module
import { greet } from "./pkg/wasm2js_memory_problem.js";

async function run() {
  try {
    const mystr = "bla".repeat(70000);
    let yada = greet(mystr);
    console.log("first done");
    const anotherstr = "blabla".repeat(70000);
    yada = greet(anotherstr);
    console.log("second done");
  } catch (err) {
    console.error("Error calling wasm function:", err);
  }
}

run().catch((err) => console.error("Error initializing wasm module:", err));
