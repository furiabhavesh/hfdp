# 1 Composite can have many Leaf nodes under it
# A Leaf node consists of "key" and "value", where "value" can be further of type string, int, array, Another composite object i.e. hash
# But "value" cannot be another Leaf node. Reason? How will you add a sibling leaf to an existing leaf node ? You need a parent for that which is basically a composite object
# Thus leaf node can only exist if there is a Composite object around it
# Composite = {} or []
# Leaf = key(Hash)/index(Array), value

# 01-enrollment-0-composite
# 02-name-1-string
# 03-ssn-1-string
# 04-phones-1-array
# 05-address-1-composite
# 06-city-5-string
# 07-office_address-1-composite
# 08-city-7-string
# 09-state-7-string
# 10-business_phones-1-composite
# 11-mumbai-10-array-
# 12-hotels-1-array-true
# 13-id-12-number-true
# 14-name-12-string-false
# 15-xyz-0-composite-true
# 16-addressess-15-array-true
# 17-home-16-string
# 17-business-16-string

data = {
  id:1,
  name:"bhavesh",
  ssn:"ABC123",
  phones:[123, 456],
  address:{city:"Pune"},
  office_address:{city:"Pune", state:"MH", zip:123456},
  business_phones:{mumbai:[987, 654]},
  hotels:[{id:1},{id:2, name: "hotel2"}],
  xyz:{"addresseses":[
    {"home-address":"Mumbai"},
    {"business-address":"Pune"}]
  }
}

class Component
  def print
    raise NotImplementedError, "#{self.class} has not implemented '#{__method__}'"
  end

  def parent
    @parent
  end

  def parent=(parent)
    @parent = parent
  end

  def add(component)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def remove(component)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def composite?
    false
  end

  def operation
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class Leaf < Component
  attr_accessor :key, :val
  def initialize(key, val)
    raise "Leaf object cannot be created without creating Composite object around it" if val.class.eql?(Leaf)
    raise "Leaf object's key property has to be either string or number. #{key.class} type received." unless [String, Fixnum].include?(key.class)
    raise "Leaf object's value cannot be of type array or hash. It has to be either of primitive type or of Composite type. Consider creating a composite around it first." if [Array, Hash].include?(val.class)
    @key = key # either string(hash key) or number(array index)
    @val = val # could be string, int, another compositeObj like arr, nested hash
  end

  def print
    if val.class.eql?(Composite)
      puts "#{key}:"
      val.items.each{|e| e.print}
    else
      puts "#{key}:#{val}"
    end
  end

  def operation
    'Leaf'
  end

  def accept(visitor)
    visitor.visit(self)
    self.val.accept(visitor) if self.val.class.eql?(Composite)
  end
end

class Composite < Component
  attr_accessor :type, :items, :item_count, :task_configs
  def initialize(type="composite")
    @type = type.to_s
    @items = []
    @item_count = 0
    @task_config = {}
  end

  def add(obj)
    raise "You can only add object of 'Leaf' type to this Composite object" unless obj.class.eql?(Leaf)
    @items << obj
    @item_count = @items.size
    obj.parent = self
    self
  end

  def remove(obj)
    raise "You can only add object of 'Leaf' type to this Composite object" unless obj.class.eql?(Leaf)
    @items.delete(obj)
    @item_count = @items.size
    obj.parent = nil
    self
  end

  def composite?
    true
  end

  def print
    @items.each{|i| i.print}
  end

  def accept(visitor)
    visitor.visit(self)
    items.each{|i|
      i.accept(visitor)
    }
  end
end

class Visitor
  @@db_config = {
    enrollment:{type: "object", ds: 1, parent: ""},
    id:{type: "number", ds: 1, parent: "enrollment"},
    name:{type: "string", ds: 2, parent: ""},
    address:{type: "object", ds: 3, parent: ""},
    city:{type: "string", ds: 3, parent: "address"}
  }

  def visit(object)
    # puts "Visiting #{object.class} object"
    # puts object.key if object.class.eql?(Leaf)
    # puts object.type if object.class.eql?(Composite)
    # puts ""

    if object.class.eql?(Composite)
      self_and_leaf_config = []
      # puts @@db_config
      # puts object.type
      self_and_leaf_config << @@db_config[object.type.to_sym][:ds] unless @@db_config[object.type.to_sym].nil?
      puts "configs-----#{self_and_leaf_config}"
    end

    # arr = @@db_config.keys.map(&:to_s)
    # if object.class.eql?(Leaf)
    #   if arr.include?(object.key.to_s)
    #     puts "Leaf valid : #{object.key}"
    #   else
    #     puts "Leaf invalid : #{object.key}"
    #   end
    # elsif object.class.eql?(Composite)
    #   puts "Composite object received"
    # end
  end
end

# c = Composite.new("enrollment")

# l = Leaf.new("id", 1)
# c.add(l)

# l = Leaf.new("name", "bhavesh")
# c.add(l)

# l = Leaf.new("ssn", "ABC123")
# c.add(l)

# l = Leaf.new("phones", Composite.new("phones").add(Leaf.new(0, 123)).add(Leaf.new(1, 456)))
# c.add(l)

# l = Leaf.new("address", Composite.new("address").add(Leaf.new("city", "Pune")))
# c.add(l)

# l = Leaf.new("office_address", Composite.new("office_address").add(Leaf.new("city", "Mumbai")).add(Leaf.new("state", "MH")).add(Leaf.new("zip", 123456)))
# c.add(l)

# l = Leaf.new("business_phones", Composite.new("business_phones").add(Leaf.new("mumbai", Composite.new.add(Leaf.new(0, 987)).add(Leaf.new(1, 654)))))
# c.add(l)

# l = Leaf.new("hotels", Composite.new("hotels").add(Leaf.new(0,Composite.new("hash").add(Leaf.new("id", 2)))).add(Leaf.new(1,Composite.new("hash").add(Leaf.new("id", 2)).add(Leaf.new("name", "hotel2")))))
# c.add(l)
# c.print

# v = Visitor.new
# c.accept(v)

# Create composite programatically------------------------------------------------------------------------------------------------
data = {
  id:1,
  name:"bhavesh",
  ssn:"ABC123",
  phones:[123, 456],
  address:{city:"Pune"},
  office_address:{city:"Pune", state:"MH", zip:123456},
  business_phones:{mumbai:[987, 654]},
  hotels:[{id:1},{id:2, name: "hotel2"}],
  xyz:{"addresseses":[
    {"home-address":"Mumbai"},
    {"business-address":"Pune"}]
  }
}

class CompositeCreator
  attr_accessor :input, :root_composite_obj
  def initialize(input, type="composite")
    raise "Input cannot be of primitive type. It should be of composite type. Eg: Array, Hash" unless [Array, Hash].include?(input.class)
    @input = input
    @root_composite_obj = Composite.new(type)
  end

  def create
    case input
    when Array
      input.each_with_index{|value, index|
        if [String, Fixnum, Float, FalseClass, TrueClass].include?(value.class)
          root_composite_obj.add(Leaf.new(index, value))
        elsif [Array, Hash].include?(value.class)
          root_composite_obj.add(Leaf.new(index.to_s, CompositeCreator.new(value).create))
        else
          puts "Invalid type #{value.class} found"
        end
      }
    when Hash
      input.each{|key, value|
        if [String, Fixnum, Float, FalseClass, TrueClass].include?(value.class)
          root_composite_obj.add(Leaf.new(key.to_s, value))
        elsif [Array, Hash].include?(value.class)
          root_composite_obj.add(Leaf.new(key.to_s, CompositeCreator.new(value).create))
        else
          puts "Invalid type #{value.class} found"
        end
      }
    else
      puts "Invalid type #{input.class} found"
    end
    root_composite_obj
  end

  def print
    root_composite_obj.print
  end
end

# c = Composite.new.add(Leaf.new(0,"bhavesh"))
# puts c.composite?

cc = CompositeCreator.new(data)
cc.create
cc.print