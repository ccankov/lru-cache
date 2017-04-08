class StaticArray
  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    @store[i]
  end

  def []=(i, val)
    validate!(i)
    @store[i] = val
  end

  def length
    @store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, @store.length - 1)
  end
end

class DynamicArray
  include Enumerable

  attr_reader :count

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    i = @count + i if i < 0
    @store[i]
  end

  def []=(i, val)
    i = @count + i if i < 0
    @store[i] = val
  end

  def capacity
    @store.length
  end

  def include?(val)
    each do |el|
      return true if el == val
    end
    false
  end

  def push(val)
    resize! if @count == capacity
    @store[count] = val
    @count += 1
  end

  def unshift(val)
    @count += 1
    new_capacity = @count == capacity ? capacity * 2 : capacity
    new_store = StaticArray.new(new_capacity)
    new_store[0] = val
    i = 1
    each do |el|
      new_store[i] = el
      i += 1
    end
    @store = new_store
    self
  end

  def pop
    return nil if @count.zero?
    val = last
    @store[count - 1] = nil
    @count -= 1
    val
  end

  def shift
    return nil if @count.zero?
    new_store = StaticArray.new(capacity)
    (1...count).each do |i|
      new_store[i - 1] = @store[i]
    end
    first_val = first
    @count -= 1
    @store = new_store
    first_val
  end

  def first
    return nil if @count.zero?
    @store[0]
  end

  def last
    return nil if @count.zero?
    @store[count - 1]
  end

  def each
    (0...count).each do |i|
      yield(@store[i])
    end
    self
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    return false unless other.length == @count
    (0...@count).each do |i|
      return false unless other[i] == self[i]
    end
    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    new_capacity = capacity * 2
    new_store = StaticArray.new(new_capacity)
    i = 0
    each do |val|
      new_store[i] = val
      i += 1
    end
    @store = new_store
  end
end
