require "./crystal_string"
require "./heap_statistics"
require "./value_error_pair"

@[Link(ldflags: "#{__DIR__}/../../ext/v8_c_bridge.cc -I#{__DIR__}/../../include -fno-rtti -std=c++11 -lstdc++ -L#{__DIR__}/../../libv8 -lv8_base -lv8_init -lv8_initializers -lv8_libbase -lv8_libplatform -lv8_libsampler -lv8_nosnapshot")]
lib LibV8
  alias Char = LibC::Char
  alias StartupData = V8::CrystalString
  alias Error = V8::CrystalString

  type Isolate = Void*
  type Context = Void*
  type PersistentValue = Void*
  type FunctionTemplate = Void*

  fun v8_init

  fun v8_Isolate_New(StartupData) : Isolate
  fun v8_Isolate_GetHeapStatistics(Isolate) : V8::HeapStatistics
  fun v8_Isolate_Release(Isolate)

  fun v8_Isolate_NewContext(Isolate) : Context
  fun v8_Context_Release(Context)

  fun v8_Context_Global(Context) : PersistentValue
  fun v8_Context_Run(Context, Char*, Char*) : V8::ValueErrorPair

  fun v8_Value_Release(Context, PersistentValue)
  fun v8_Value_Get(Context, PersistentValue, Char*) : V8::ValueErrorPair
  fun v8_Value_Set(Context, PersistentValue, Char*, PersistentValue) : Error
  fun v8_Value_String(Context, PersistentValue) : V8::CrystalString
  fun v8_Value_IsFunction(Context, PersistentValue) : Bool
  fun v8_Function_Call(Context, fn : PersistentValue, this : PersistentValue, length : Int32, args : PersistentValue*) : V8::ValueErrorPair

  fun v8_Object_New(Context) : PersistentValue
  fun v8_String_New(Context, Char*) : PersistentValue

  fun v8_FunctionTemplate_New(Context, Char*, Char*) : PersistentValue

  struct Version
    major : Int32
    minor : Int32
    build : Int32
    patch : Int32
  end

  fun v8_Version : Version

  VERSION = ::String.build do |str|
    v8v = LibV8.v8_Version
    str << "#{v8v.major}.#{v8v.minor}.#{v8v.build}.#{v8v.patch}"
  end
end
