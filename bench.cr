require "./src/v8"
require "benchmark"

iso = V8::Isolate.new
ctx = V8::Context.new(iso)

global = ctx.global

global.set "fn", V8::CrystalFunction.new(ctx, "fn", V8::FunctionCallback.new do |info|
  return nil
end)

ctx.eval "function hello(){ return \"world\" }"
ctx.eval "function cb(){ return fn() }"
ctx.eval "var value = null"

ret = global.get("hello")
fn = ret.not_nil!

retcb = global.get("cb")
cb = retcb.not_nil!

Benchmark.ips do |x|
  x.report("get a value") {
    ctx.global.get("value")
  }
  x.report("eval") {
    ctx.eval "(function(){})"
  }
  x.report("create an object") {
    V8::Object.new(ctx)
  }
  x.report("bind a function") {
    V8::CrystalFunction.new(ctx, "", V8::FunctionCallback.new do |info|
      return nil
    end)
  }
  # x.report("get heap statistics") {
  #   iso.heap_statistics
  # }
  x.report("call a function") {
    fn.call
  }
  x.report("call a function calling a callback") {
    cb.call
  }
end