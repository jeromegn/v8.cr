module V8
  class Value
    def initialize(@ctx : Context, @ptr : LibV8::PersistentValue)
    end
  
    def function?
      LibV8.v8_Value_IsFunction(@ctx, self)
    end

    def call
      raise "not a function" if !function?
      result = LibV8.v8_Function_Call(@ctx, self, Object.new(@ctx), 0, [Object.new(@ctx).to_unsafe])
      raise result.error.not_nil! if result.error
      return result.get_value(@ctx)
    end

    def to_s
      LibV8.v8_Value_String(@ctx, self).to_s
    end

    def to_unsafe
      @ptr
    end

    def release
      LibV8.v8_Value_Release(@ctx, self)
    end

    # def finalize
    #   release
    # end
  end
end