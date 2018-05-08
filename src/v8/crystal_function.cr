require "../lib_v8"
require "./function_callback"

module V8
  class CrystalFunction
    getter callback : FunctionCallback
    getter ctx : Context
    @callback_id : String = Random.new.hex
    @@callbacks = {} of String => V8::CrystalFunction
    @@callback : LibV8::FunctionCallbackInfo-> = ->(info : LibV8::FunctionCallbackInfo){
      puts "in fn, sizeof info:", sizeof(typeof(info))
      cb_id = LibV8.v8_FunctionCallbackInfo_Data(info).to_s
      fn = @@callbacks[cb_id]?
      return if fn.nil?
      parsed_info = LibV8.v8_FunctionCallbackInfo(info)
      ret = fn.callback.call(FunctionCallbackInfo.new(fn.ctx, parsed_info))
      puts "returned:", ret
      return if ret.nil?
    }
    def initialize(@ctx : Context, name : String, @callback : FunctionCallback)
      @ptr = LibV8.v8_FunctionTemplate_New(@ctx, @@callback, @callback_id)
      @@callbacks[@callback_id] = self
    end

    def release
      LibV8.v8_Value_Release(@ctx, self)
    end

    def to_unsafe
      @ptr
    end

    # def finalize
    #   release
    # end
  end
end