require "./value"

module V8
  class String < Value
    def initialize(@ctx : Context, str : ::String)
      @ptr = LibV8.v8_String_New(@ctx, str)
    end
  end
end