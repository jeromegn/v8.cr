require "../lib_v8"
require "./value"
require "./context"

module V8
  alias FunctionCallback = Proc(FunctionCallbackInfo,Value?)
  
  struct FunctionCallbackInfo
    # private property raw : LibV8::FunctionCallbackInfo
    # getter this : Value
    getter args : Slice(Value)
    getter length : LibC::Int

    def initialize(ctx : Context, parsed : LibV8::ParsedFunctionCallbackInfo)
      puts "sizeof parsed thing: #{sizeof(typeof(parsed))}"
      # puts "this pointer: #{parsed.this}"
      # @this = Value.new(ctx, parsed.this)
      @length = parsed.length
      puts "initial pointer: #{parsed.args}"
      args = Slice.new(parsed.args, parsed.length.to_i)
      @args = args.map_with_index do |ptr, i|
        puts "arg #{i}"
        p ptr
        Value.new(ctx, ptr)
      end
      puts typeof(args), sizeof(typeof(args))
    end

  end
end

# module V8
#   struct FunctionCallback
#     @@callbacks = Array(LibV8::FunctionCallbackInfo -> ).new
#     property cb : FunctionCallbackInfo ->
#     property unsafe_cb : LibV8::FunctionCallbackInfo->
#     def initialize(@cb)
#       @unsafe_cb = FunctionCallback.parse_cb(@cb)
#       @@callbacks.push @unsafe_cb
#     end

#     def self.parse_cb(cb : FunctionCallbackInfo ->)
#       return -> (info : LibV8::FunctionCallbackInfo) {
#         cb(LibV8.)
#       }
#     end

#     def to_unsafe
#       unsafe_cb
#     end
#   end
# end