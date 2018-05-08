require "./value"

module V8
  class Object < Value
    def initialize(@ctx : Context, ptr : LibV8::PersistentValue)
      @ptr = ptr.null? ? LibV8.v8_Object_New(@ctx) : ptr
    end

    def set(field : String, value : Value | CrystalFunction)
      error = LibV8.v8_Value_Set(@ctx, self, field, value)
      unless error.ptr.null?
        raise String.new(error.ptr, error.size)
      end
    end

    def get(field : String)
      result = LibV8.v8_Value_Get(@ctx, self, field)
      raise result.error if result.error
      return result.value(@ctx)
    end
  end
end