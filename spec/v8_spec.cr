require "./spec_helper"

describe V8::Isolate do
  it "works" do
    V8::Isolate.new
  end
end

describe V8::Context do
  it "works" do
    V8::Context.new(V8::Isolate.new)
  end
end