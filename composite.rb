input = {
  "enrollment": {
    "npi-number":"1861440315",
    "address":{
      "home": "Mumbai",
      "office": "Pune"
    }
  }
}

# @db_data = db_data || [
#   {id: 1, parent_id: 0, label: "enrollment", type: "object", required: true},
#   {id: 2, parent_id: 1, label: "npi-number", type: "string", required: true},
#   {id: 3, parent_id: 1, label: "address", type: "object", required: true},
#   {id: 4, parent_id: 3, label: "home", type: "string", required: true},
#   {id: 5, parent_id: 3, label: "office", type: "string", required: false}
# ]

# class Translator
#   attr_accessor 
  
#   def translator(input)
#     input.each{|key, value|
#       if input[key]
#     }
#   end

#   def compare(hash1, hash2)
#     args = [hash1, hash2]

#     return true if args.all? {|h| h.nil?}
#     return false if args.one? {|h| h.nil?}

#     hash1.each_key do |k|
#       values = [hash1[k], hash2[k]]

#       if values.all? {|h| h.is_a?(Hash)}
#         return compare(*values)
#       else
#         return false if values.one? {|value| value.nil? }
#       end
#     end
#     true
#   end
# end


module Component
  def print
  end
end

class Leaf # SimpleObject
  include Component
  attr_accessor :name, :data_source

  def initialize(name, data_source)
    @name = name
    @data_source = data_source
  end

  def print
    puts "#{self.class}---#{name}----#{data_source}"
  end

  def accept(visitor)
    visitor.visit(self)
  end
end

class Composite
  include Component

  attr_accessor :name, :children, :data_source, :child_count

  def initialize(name, data_source)
    @name = name
    @data_source = data_source
    @children = []
    @child_count = 0
  end

  def add(child)
    @children << child
    @child_count = @child_count + 1
    self
  end

  def print
    puts "#{self.class}---#{name}----#{data_source}"
    @children.each{|child|child.print}
  end

  def get_child_at(index)
    @children[index]
  end

  def accept(visitor)
    visitor.visit(self)
  end
end

class CompositeObject < Composite

end

class CompositeArray < Composite

end

class CompositeVisitor
  attr_accessor :tasks_collection

  def initialize
    @tasks_collection = []
  end

  def visit(obj)
    obj
  end
end

enrollment = Composite.new("enrollment", nil).add(
          Composite.new("address", nil).add(
            Leaf.new("work_address", "www.address.com")).add(
            Leaf.new("home_address", "www.address.com")).add(
            Leaf.new("business_address", "www.address.com"))).add(
          Leaf.new("ssn", "www.ssn.com")
        )
cv = CompositeVisitor.new.visit(enrollment)
puts enrollment.inspect