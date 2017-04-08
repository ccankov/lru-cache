require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map[key].nil?
      eject! if count == @max
      calc!(key)
    else
      update_link!(@map[key])
    end
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def calc!(key)
    # suggested helper method; insert an (un-cached) key
    val = @prc.call(key)
    @store.append(key, val)
    @map.set(key, @store.last)
    val
  end

  def update_link!(link)
    # suggested helper method; move a link to the end of the list
    @store.remove(link.key)
    @store.append(link.key, link.val)
    @map.set(link.key, @store.last)
    link.val
  end

  def eject!
    link = @store.first
    link.remove
    @map.delete(link.key)
  end
end
