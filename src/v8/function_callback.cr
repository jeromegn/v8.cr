require "./lib_v8"
require "./value"
require "./context"

module V8
  alias FunctionCallback = Proc(FunctionCallbackInfo, Value?)

  struct FunctionCallbackInfo
    getter args : Slice(Value)
    getter length : LibC::Int

    def initialize(@length : Int, @args : Slice(Value))
    end
  end
end
