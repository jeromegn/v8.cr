require "./v8/crystal_string"
require "./v8/heap_statistics"
require "./v8/value_error_pair"

@[Link(ldflags: "#{__DIR__}/v8_c_bridge.o -lstdc++ -L#{__DIR__}/../libv8 -lv8_base -lv8_init -lv8_initializers -lv8_libbase -lv8_libplatform -lv8_libsampler -lv8_nosnapshot")]
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
  fun v8_Function_Call(Context, PersistentValue, this : PersistentValue, length : Int32, args : PersistentValue*) : V8::ValueErrorPair

  fun v8_Object_New(Context) : PersistentValue

  # struct FunctionCallbackInfo
  #   # _implicit_args : 
  #   pad : Char[24]
  # end
  type FunctionCallbackInfo = Void*

  fun v8_FunctionTemplate_New(Context, callback : FunctionCallbackInfo->, Char*) : PersistentValue

  struct ParsedFunctionCallbackInfo
    length : LibC::Int
    args : PersistentValue*
  end

  fun v8_FunctionCallbackInfo_Data(FunctionCallbackInfo) : V8::CrystalString
  fun v8_FunctionCallbackInfo(FunctionCallbackInfo) : ParsedFunctionCallbackInfo
  
  struct Version
    major : Int32
    minor : Int32
    build : Int32
    patch : Int32
  end
  fun v8_Version : Version

  # enum Kind
  #   Undefined
  #   Null
  #   True
  #   False
  #   Name
  #   String
  #   Symbol
  #   Function
  #   Array
  #   Object
  #   Boolean
  #   Number
  #   External
  #   Int32
  #   Uint32
  #   Date
  #   ArgumentsObject
  #   BooleanObject
  #   NumberObject
  #   StringObject
  #   SymbolObject
  #   NativeError
  #   RegExp
  #   AsyncFunction
  #   GeneratorFunction
  #   GeneratorObject
  #   Promise
  #   Map
  #   Set
  #   MapIterator
  #   SetIterator
  #   WeakMap
  #   WeakSet
  #   ArrayBuffer
  #   ArrayBufferView
  #   TypedArray
  #   Uint8Array
  #   Uint8ClampedArray
  #   Int8Array
  #   Uint16Array
  #   Int16Array
  #   Uint32Array
  #   Int32Array
  #   Float32Array
  #   Float64Array
  #   DataView
  #   SharedArrayBuffer
  #   Proxy
  #   WebAssemblyCompiledModule
  # end
end

