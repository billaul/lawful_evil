module Undigits
  refine Array do
    def undigits(base = 10)
      each_with_index.sum do |digit, exponent|
        digit * base**exponent
      end
    end
  end
end

using Undigits
