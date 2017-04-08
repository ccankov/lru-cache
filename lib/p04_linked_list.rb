class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.
    @next.prev = @prev
    @prev.next = @next
    true
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head, @tail = Link.new(:head), Link.new(:tail)
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next unless empty?

  end

  def last
    @tail.prev unless empty?
  end

  def empty?
    @head.next == @tail
  end

  def get(key)
    link = get_link(key)
    link.nil? ? nil : link.val

  end

  def include?(key)
    !get_link(key).nil?
  end

  def append(key, val)
    new_link = Link.new(key, val)
    old_prev = @tail.prev
    old_prev.next = new_link
    new_link.prev = old_prev
    new_link.next = @tail
    @tail.prev = new_link

  end

  def update(key, val)
    found_link = get_link(key)
    found_link.val = val unless found_link.nil?

  end

  def remove(key)
    link = get_link(key)
    link.nil? ? nil : link.remove
  end

  def each
    current_link = @head.next
    until current_link.next.nil?
      yield current_link
      current_link = current_link.next
    end

    self
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end

  private
  def get_link(key)
    each {|link| return link if link.key == key}
    nil
  end
end
