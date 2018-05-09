require "../src/v8"
require "http/server"

puts V8::VERSION

# spawn do
iso = V8::Isolate.new
ctx = V8::Context.new(iso)

puts Fiber.current.get_stack_bottom

fetchFn = uninitialized V8::Value

logfn = V8::CrystalFunction.new(ctx, "log", V8::FunctionCallback.new do |info|
  puts "in log!"
  puts info.args.map(&.to_s).join(" ")
  nil
end)

cfn = V8::CrystalFunction.new(ctx, "addEventListener", V8::FunctionCallback.new do |info|
  puts "cr function"
  info.args.each do |a|
    puts "arg: '#{a.to_s}'"
  end
  fetchFn = info.args[1]
  nil
end)

global = ctx.global
global.set("log", logfn)
global.set("addEventListener", cfn)

s = File.read("examples/script.js").to_s
ctx.eval(s)

spawn do
  loop do
    sleep 2.seconds
    hs = iso.heap_statistics
    puts "heap: #{hs.total_heap_size / (1024 * 1024.0)} MB"
    # puts hs
  end
end

# sleep 1.second

# spawn do
#   puts Fiber.current.get_stack_bottom
#   res = fetchFn.not_nil!.call
#   puts "after call"
#   puts res.to_s
# end

# sleep 1.second

# end

# sleep 5.second

# sleep 2.second

server = HTTP::Server.new(9090) do |context|
  # puts "hello server handler"
  # context.response.print("woot")
  begin
    ret = fetchFn.not_nil!.call
    context.response.print(ret.to_s)
  rescue ex : Exception
    context.response.print("#{ex.message}\n#{ex.backtrace.join("\n")}")
  end
end

puts "Listening on http://127.0.0.1:8080"
server.listen
