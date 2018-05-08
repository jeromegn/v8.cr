module V8
  class Isolate
    def initialize
      puts "initing iso"
      @ptr = LibV8.v8_Isolate_New(LibV8::StartupData.new("".to_unsafe, 0))
      puts "init iso"
    end

    def to_unsafe
      @ptr
    end

    def heap_statistics
      LibV8.v8_Isolate_GetHeapStatistics(self)
    end

    def create_context
      Context.new(self)
    end

    def release
      LibV8.v8_Isolate_Release(self)
    end

    # def finalize
    #   release
    # end
  end
end