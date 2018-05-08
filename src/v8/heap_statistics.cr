module V8
  @[Extern]
  struct HeapStatistics
    property total_heap_size : UInt64
    property total_heap_size_executable : UInt64
    property total_physical_size : UInt64
    property total_available_size : UInt64
    property used_heap_size : UInt64
    property heap_size_limit : UInt64
    property malloced_memory : UInt64
    property peak_malloced_memory : UInt64
    property does_zap_garbage : Bool

    def initialize(@total_heap_size, @total_heap_size_executable, @total_physical_size, @total_available_size, @used_heap_size, @heap_size_limit, @malloced_memory, @peak_malloced_memory, @does_zap_garbage)
    end
  end
end