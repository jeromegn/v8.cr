require "../lib_v8.cr"
module V8
  VERSION = String.build do |str|
    v8v = LibV8.v8_Version()
    str << "#{v8v.major}.#{v8v.minor}.#{v8v.build}.#{v8v.patch}"
  end
end