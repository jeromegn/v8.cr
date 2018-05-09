require "./value"
require "./object"

module V8
  class Context
    @@contexts = {} of ::String => Context

    @id : ::String = Random.new.hex(4)
    getter id

    def initialize(@iso : Isolate)
      @ptr = LibV8.v8_Isolate_NewContext(iso)
      @@contexts[@id] = self
    end

    def self.contexts
      @@contexts
    end

    def global : Object
      Object.new(self, LibV8.v8_Context_Global(self))
    end

    def create_function(name : ::String, cb : FunctionCallback)
      CrystalFunction.new(self, name, cb)
    end

    def eval(code : ::String, filename = "script.js")
      valerr = LibV8.v8_Context_Run(self, code, filename)
      raise valerr.error.not_nil! unless valerr.error.nil?
      valerr.get_value(self)
    end

    def release
      LibV8.v8_Context_Release(self)
    end

    def to_unsafe
      @ptr
    end

    def finalize
      release
    end
  end
end
