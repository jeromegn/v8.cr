require "../src/v8"

iso = V8::Isolate.new
ctx = V8::Context.new(iso)

fetchFn = uninitialized V8::Value

cfn = V8::CrystalFunction.new(ctx, "blah", V8::FunctionCallback.new do |info|
  info.args.each do |a|
    puts "arg: '#{a.to_s}'"
  end
  nil
end)

global = ctx.global
global.set("addEventListener", cfn)

s = File.read("examples/script.js").to_s
ctx.eval(s)