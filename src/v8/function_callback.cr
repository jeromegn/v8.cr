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

    def initialize(@length : Int, @args : Slice(Value))
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