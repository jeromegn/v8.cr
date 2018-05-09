require "./lib_v8"
require "./context"

module V8
  @[Extern]
  struct ValueErrorPair
    private property value_ptr : LibV8::PersistentValue
    private property error_string : LibV8::Error

    def initialize(@value_ptr, @error_string)
    end

    def error
      return nil if error_string.ptr.null?
      ::Exception.new(error_string.to_s)
    end

    def get_value(ctx : Context)
      return nil if value_ptr.null?
      Value.new(ctx, value_ptr)
    end
  end
end
