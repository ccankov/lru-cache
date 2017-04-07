class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    return 5825619678678687678678.hash if length < 1
    current_hash = first.hash
    self[1..-1].each_with_index do |el, i|
      current_hash = current_hash ^ (el + i + 1).hash
    end
    current_hash
  end
end

class String
  def hash
    s_array = self.split("").map{|chr| chr.ord}
    s_array.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    array = self.map {|key, val| key.hash+ val.hash}
    array.sort!
    array.hash
  end
end
