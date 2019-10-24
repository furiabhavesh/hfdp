class Duck
  attr_accessor :name

  def initialize(name="")
    @name = name
  end

  def fly
    puts "#{self.class} is flying"
  end

  def quack
    puts "#{self.class} is quacking"
  end
end

class HealthyDuck < Duck;end

class HandicappedDuck < Duck
  def fly
    puts "#{self.class} can't fly"
  end
end

class WoodenDuck < Duck
  def fly
    puts "#{self.class} can't fly"
  end

  def quack
    puts "#{self.class} can't quack"
  end
end

a = HealthyDuck.new
a.fly
a.quack

h = HandicappedDuck.new
h.fly
h.quack

w = WoodenDuck.new
w.fly
w.quack

# solution below

class Flyable
  def fly
    raise 'Abstract method called'
  end
end

class WingFly < Flyable
  def fly(name)
    puts "#{name} can fly"
  end
end

class NoFly < Flyable
  def fly(name)
    puts "#{name} can't fly"
  end
end

class Duck
  attr_accessor :flyable

  def initialize(name="", flyable)
    @name = name
    puts "#{flyable.class} passed----------------------"
    @flyable = flyable
  end

  def perform_fly
    @flyable.fly(@name)
  end
end

class HealthyDuck < Duck
end

class HandicappedDuck < Duck
end

class WoodenDuck < Duck
end

h = HealthyDuck.new("Healthy", WingFly.new)
h.perform_fly

h = HandicappedDuck.new("Handicapped", NoFly.new)
h.perform_fly

w = WoodenDuck.new("Wooden", NoFly.new)
w.perform_fly