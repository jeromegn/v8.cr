require "./v8/*"

class Fiber
  def get_stack
    @stack
  end
end

fun __crystal_current_fiber_stack : Void*
  Fiber.current.get_stack
end

fun __crystal_v8_callback_handler(id : V8::CrystalString, argc : LibC::Int, argv : LibV8::PersistentValue*)
  ctx_id, fn_id = id.to_s.split(":")

  ctx = V8::Context.contexts[ctx_id]?
  return if ctx.nil?

  fn = V8::CrystalFunction.callbacks[fn_id]?
  return if fn.nil?

  args = Slice.new(argv, argc).map do |ptr|
    V8::Value.new(ctx, ptr)
  end

  begin
    return fn.callback.call(V8::FunctionCallbackInfo.new(argc, args))
  rescue ex : Exception
    puts "exception!", ex
  end
end

# do this once.
LibV8.v8_init
