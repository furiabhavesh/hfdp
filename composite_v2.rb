data = {
  cell_nos:[{"office":123, "home":456}]
}

module Component
  def print
    puts self.inspect
  end
end

class Leaf
  include Component
  attr_accessor :key, :value

  def initialize(key, value)
    @key = key
    @value = value
  end

  def print
    puts "-----#{self.class}-----"
    p "#{key}: #{value}"
  end

  alias to_s print
end

class Composite
  include Component
  attr_accessor :name, :children, :child_count
  
  def initialize(name)
    @name = name
    @children = []
    @child_count = 0
  end

  def add(child)
    @children << child
    @child_count = @child_count + 1
    self
  end

  def print
    puts "-----#{self.class}-----"
    puts "#{name}"
    @children.each{|child|child.print}
  end
end

class CompositeArray < Composite
  attr_accessor :key, :items, :item_count

  def initialize(key, items)
    @key = key
    @items = items
    @item_count = items.size
  end

  def print
    puts "-----#{self.class}-----"
    puts "#{key}:"
    items.each{|item|
      puts item.to_s
    }
  end
end

class CompositeObj < Composite
  attr_accessor :key, :obj
  
  def initialize(key, obj)
    @key = key
    @obj = obj
  end

  def print
    puts "-----#{self.class}-----"
    puts "#{key}:"
    puts "#{obj.print}"
  end
end

# l = Leaf.new("name", "bhavesh")
# l.print

# ca = CompositeArray.new("phone_nos",[123,456])
# ca.print

# cca = CompositeArray.new("phone_nos",[Leaf.new("office","123"), 456])
# cca.print

# co = CompositeObj.new("address", Leaf.new("city", "Pune"))
# co.print

d = Composite.new("enrollment").add(Leaf.new("name","bhavesh")).add(CompositeObj.new("address", Leaf.new("city", "Pune"))).add(CompositeArray.new("phone_nos",[Leaf.new("office","123"), 456, "pqr"])).add(Leaf.new("ssn","ABC123"))
d.print

d = Composite.new("enrollment").add(CompositeArray.new("cell_nos",[]))

# d = CompositeArray.new("phone_nos",[Leaf.new("office","123"), 456])
# d.print
# puts d.inspect