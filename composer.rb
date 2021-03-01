class Composer
  # delegate delegate_missing_to :up_level

  def self.configure(*args, &block)
    obj = self.new
    obj.config(*args) unless args.empty?
    obj.instance_exec(&block) if block_given?
    obj
  end

  def config(*args)
    raise NoMethodError
  end

  def initialize(*args )
    @args = args
    @sub_levels = []
  end

  def wrap(sub_level)
    @sub_level <<
      if sub_level.respond_to? :new
        sub_level.new
      else
        sub_level
      end
    self
  end
end

class FancyComposer < Composer
  def make_it_fancy(...)
    raise NoMethodError
  end
end

class StrComposer < FancyComposer
  attr_accessor :string

  def config(string)
    @string = string
  end

  def make_it_fancy
    @sub_levels.each do |sub_level|
      self.string = sub_level.make_it_fancy(string)
    end
    string
  end
end

class Upcase < FancyComposer
  def make_it_fancy(str)
    str.upcase
  end
end

class Downcase < FancyComposer
  def make_it_fancy(str)
    str.downcase
  end
end

class Tr < FancyComposer
  attr_reader :old_char
  attr_reader :new_char

  def config(old_char, new_char)
    @old_char = old_char
    @new_char = new_char
  end

  def make_it_fancy(str)
    str.tr(old_char, new_char)
  end
end

class MakeItTwice < FancyComposer
  def make_it_fancy(str)
    str + str
  end
end

class Prefix < FancyComposer
  attr_reader :prefix

  def config(prefix)
    @prefix = prefix
  end

  def make_it_fancy(str)
    "#{prefix} #{str}"
  end
end

class Sufix < FancyComposer
  attr_reader :sufix

  def config(sufix)
    @sufix = sufix
  end
  def make_it_fancy(str)
    "#{str} #{sufix}"
  end
end

class WordFirstLetter < FancyComposer
  def make_it_fancy(str)
    str.split(' ').map do |word|
      @sub_levels.each do |sub_level|
        word[0] = sub_level.make_it_fancy(word[0])
      end
      word
    end.join(' ')
  end
end

class WordLastLetter < FancyComposer
  def make_it_fancy(str)
    str.split(' ').map do |word|
      @sub_levels.each do |sub_level|
        word[-1] = sub_level.make_it_fancy(word[-1])
      end
      word
    end.join(' ')
  end
end

class Erase < FancyComposer
  def make_it_fancy(str)
    return ''
  end
end

decorated_string = StrComposer.configure('This is a test') do
  wrap Upcase
  wrap WordFirstLetter.configure {
    wrap Downcase
    wrap MakeItTwice
  }
  wrap(WordLastLetter.configure do
    wrap Erase
  end)
  wrap Tr.configure(' ', '-')
  wrap Prefix.configure('Attention:')
  wrap Sufix.configure('!!!')
end

fancy_string = decorated_string.make_it_fancy
puts fancy_string # Attention: ttHI-ii-a-ttES !!!
