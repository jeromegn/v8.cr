require "./lib_v8"
require "./v8/*"

@[Extern]
struct ErrorString
  property ptr : LibC::Char*
  property size : LibC::Int
  def initialize(@ptr, @size)
  end
end

@[Extern]
struct ValueErrorPairC
  property value : Void*
  property error_msg : ErrorString
  def initialize(@value, @error_msg)
  end
end

fun __crystal_v8_callback_handler(id : V8::CrystalString, argc : LibC::Int, argv : LibV8::PersistentValue*)
  ctx_id, fn_id = id.to_s.split(":")

  puts "ctx id: #{ctx_id}, fn_id: #{fn_id}"

  ctx = V8::Context.contexts[ctx_id]?
  return if ctx.nil?

  puts "ctx was not nil"

  fn = V8::CrystalFunction.callbacks[fn_id]?
  return if fn.nil?

  puts "fn was not nil"

  args = Slice.new(argv, argc).map do |ptr|
    V8::Value.new(ctx, ptr)
  end

  begin
    ret = fn.callback.call(V8::FunctionCallbackInfo.new(argc, args))
    # if ret.nil?
    #   retnil = uninitialized LibV8::PersistentValue
    #   return V8::ValueErrorPair.new(retnil, V8::CrystalString.new(Pointer(UInt8).null, 0))
    # else
    #   return V8::ValueErrorPair.new(ret.to_unsafe, V8::CrystalString.new(Pointer(UInt8).null, 0))
    # end
    
  rescue ex : Exception
    puts "exception!", ex
    # msg : String = ex.message.nil? ? "something went very wrong" : ex.message.not_nil!
    # v = uninitialized LibV8::PersistentValue
    # return V8::ValueErrorPair.new(v, V8::CrystalString.new(msg.to_unsafe, msg.size))
  end
  # return ValueErrorPairC.new(Pointer(Void).null, ErrorString.new(Pointer(UInt8).null, 0))
  return nil
end

# do this once.
LibV8.v8_init