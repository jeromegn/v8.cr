module V8
  @[Extern]
  struct CrystalString
    property ptr : LibC::Char*
    property size : LibC::Int

    def initialize(@ptr, @size)
    end

    def to_s
      ::String.new(ptr, size)
    end
  end
end
