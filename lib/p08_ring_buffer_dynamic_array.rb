require 'byebug'
# Implementation of a static array from C
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
    raise 'Overflow error' unless i.between?(0, @store.length - 1)
  end
end

# Custom implementation of Ruby's built-in dynamic array
class DynamicArray
  include Enumerable

  attr_reader :count

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
    @start_idx = capacity / 2
  end

  def [](i)
    i = @count + i if i < 0
    return nil if i >= @count || i < 0
    arr_idx = get_ring_idx(i)
    @store[arr_idx]
  end

  def []=(i, val)
    i = @count + i if i < 0
    push(nil) until @count == i + 1 if i > @count
    arr_idx = get_ring_idx(i)
    @store[arr_idx] = val
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
    arr_idx = get_ring_idx(count)
    @store[arr_idx] = val
    @count += 1
  end

  def unshift(val)
    resize! if @count == capacity
    @start_idx -= 1
    @start_idx = @start_idx % capacity
    @store[@start_idx] = val
    @count += 1
  end

  def pop
    return nil if @count.zero?
    val = last
    arr_idx = get_ring_idx(count - 1)
    @store[arr_idx] = nil
    @count -= 1
    val
  end

  def shift
    return nil if @count.zero?
    val = first
    @store[@start_idx] = nil
    @start_idx += 1
    @start_idx = (@start_idx % capacity)
    @count -= 1
    val
  end

  def first
    return nil if @count.zero?
    # debugger
    @store[@start_idx]
  end

  def last
    return nil if @count.zero?
    arr_idx = get_ring_idx(count - 1)
    @store[arr_idx]
  end

  def each
    (0...count).each do |i|
      arr_idx = get_ring_idx(i)
      yield(@store[arr_idx])
    end
    self
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    return false unless other.count == @count
    (0...@count).each do |i|
      arr_idx = get_ring_idx(i)
      return false unless other[i] == @store[arr_idx]
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
      arr_idx = (i + (new_capacity / 2)) % new_capacity
      new_store[arr_idx] = val
      i += 1
    end
    @store = new_store
    @start_idx = new_capacity / 2
  end

  def get_ring_idx(idx)
    (idx + @start_idx) % capacity
  end
end
