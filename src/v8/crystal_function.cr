require "./lib_v8"
require "./function_callback"

module V8
  class CrystalFunction
    getter callback : FunctionCallback
    getter ctx : Context
    @id : ::String = Random.new.hex(4)
    @@callbacks = {} of ::String => V8::CrystalFunction

    def self.callbacks
      @@callbacks
    end

    def initialize(@ctx : Context, name : ::String, @callback : FunctionCallback)
      @ptr = LibV8.v8_FunctionTemplate_New(@ctx, name, "#{ctx.id}:#{@id}")
      @@callbacks[@id] = self
    end

    def release
      LibV8.v8_Value_Release(@ctx, self)
    end

    def to_unsafe
      @ptr
    end

    def finalize
      release
    end
  end
end
