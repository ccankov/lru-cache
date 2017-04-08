require_relative 'p02_hashing'
require_relative 'p04_linked_list'

class HashMap
  include Enumerable

  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key).include?(key)
  end

  def set(key, val)
    resize! if count == num_buckets
    bucket = bucket(key)
    if bucket.include?(key)
      bucket.update(key, val)
    else
      bucket.append(key, val)
      @count += 1
    end

  end

  def get(key)
    bucket = bucket(key)
    bucket.get(key)
  end

  def delete(key)
    bucket = bucket(key)
    bucket.remove(key) ? @count -= 1 : nil
  end

  def each
    @store.each do |bucket|
      bucket.each do |link|
        yield link.key, link.val
      end
    end
    self
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    new_num_buckets = num_buckets * 2
    new_store = Array.new(new_num_buckets){LinkedList.new}
    each do |key, val|
      hash = key.hash
      bucket = new_store[hash % new_num_buckets]
      bucket.append(key, val)
    end
    @store = new_store
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    hash = key.hash
    @store[hash % num_buckets]
  end
end
