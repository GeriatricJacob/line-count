RSpec::Matchers.define :be_a_color do |r,g,b,a|
  match do |actual|
    actual.red == r &&
    actual.green == g &&
    actual.blue == b &&
    actual.alpha == a
  end

  description do
    "be a color with components red=#{r}, green=#{g}, blue=#{b} and alpha=#{a}"
  end
end
