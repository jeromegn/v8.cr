require "../src/v8"

iso = V8::Isolate.new
ctx = iso.create_context

puts V8::VERSION

# fn = ctx.create_function -> (info : LibV8::FunctionCallbackInfo) {
#   puts "hello crystal", info
# }

fn = V8::CrystalFunction.new(ctx, "blah", V8::FunctionCallback.new do |info|
  puts "hello crystal", info
  return nil
end)
fn2 = V8::CrystalFunction.new(ctx, "blah", V8::FunctionCallback.new do |info|
  puts "hello crystal 22222", info
  return nil
end)

# puts "fn function?", fn.function?

global = ctx.global
puts global.to_s

global.set("cb", fn)
global.set("cb2", fn2)

p iso.heap_statistics

20.times do
  begin
    ctx.eval "cb('boom'); cb2(123, 456)"
  rescue ex : Exception
    puts "rescued!", ex
  end
end

p iso.heap_statistics

global.set("cb", fn)
global.set("cb2", fn2)

p iso.heap_statistics

20.times do
  begin
    ctx.eval "cb('boom'); cb2(123, 456)"
  rescue ex : Exception
    puts "rescued!", ex
  end
end

p iso.heap_statistics
