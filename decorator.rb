class Decorator
  attr_reader :sub_level

  def initialize(*args, &block)
    config(*args) unless args.empty?
    @sub_level = yield
  end

  def config(*args)
    raise NoMethodError
  end
end

# Interface

module FancyInterface
  def make_it_fancy(...)
    raise NoMethodError
  end
end

class FancyDecorator < Decorator
  include FancyInterface
end

class Message
  include FancyInterface
  
  def initialize(string)
    @string = string
  end

  def make_it_fancy
    @string
  end
end

class Upcase < FancyDecorator
  def make_it_fancy
    sub_level.make_it_fancy.upcase
  end
end

class Downcase < FancyDecorator
  def make_it_fancy
    sub_level.make_it_fancy.downcase
  end
end

class Tr < FancyDecorator
  attr_reader :old_char
  attr_reader :new_char

  def config(old_char, new_char)
    @old_char = old_char
    @new_char = new_char
  end

  def make_it_fancy
    sub_level.make_it_fancy.tr(old_char, new_char)
  end
end

class Prefix < FancyDecorator
  attr_reader :prefix

  def config(prefix)
    @prefix = prefix
  end

  def make_it_fancy
    "#{prefix} #{sub_level.make_it_fancy}"
  end
end

class Sufix < FancyDecorator
  attr_reader :sufix

  def config(sufix)
    @sufix = sufix
  end
  def make_it_fancy
    "#{sub_level.make_it_fancy} #{sufix}"
  end
end

decorated_string =
  Sufix.new('!!!') do
    Prefix.new('Attention:') do
      Tr.new(' ', '-') do
        Upcase.new do
          Message.new('This is a test')
        end
      end
    end
  end

fancy_string = decorated_string.make_it_fancy
puts fancy_string # Attention: THIS-IS-A-TEST !!!
