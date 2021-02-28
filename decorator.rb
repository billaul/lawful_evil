class Decorator

  def self.configure(*args, &block)
    obj = self.new(*args)
    obj.instance_exec(&block) if block_given?
    obj
  end

  def initialize(*args )
    @args = args
    @sub_levels = []
  end

  def wrap(sub_level)
    @sub_levels <<
      if sub_level.respond_to? :new
        sub_level.new
      else
        sub_level
      end
    self
  end

end

class StrDecorator < Decorator
  def make_it_fancy
    str = @args.first
    @sub_levels.each do |sub_level|
      str = sub_level.make_it_fancy(str)
    end
    puts str
  end
end

class Upcase < Decorator
  def make_it_fancy(str)
    str.upcase
  end
end

class Downcase < Decorator
  def make_it_fancy(str)
    str.downcase
  end
end

class Tr < Decorator
  def make_it_fancy(str)
    str.tr(@args[0], @args[1])
  end
end

class MakeItTwice < Decorator
  def make_it_fancy(str)
    str + str
  end
end

class Prefix < Decorator
  def make_it_fancy(str)
    "#{@args.first} #{str}"
  end
end

class Sufix < Decorator
  def make_it_fancy(str)
    "#{str} #{@args.first}"
  end
end

class FirstLetters < Decorator
  def make_it_fancy(str)
    str.split(' ').map do |word|
      @sub_levels.each do |sub_level|
        word[0] = sub_level.make_it_fancy(word[0])
      end
      word
    end.join(' ')
  end
end


decorated_string =
  StrDecorator.configure('This is a test') do
    wrap Upcase
    wrap( FirstLetters.configure do
      wrap Downcase
      wrap MakeItTwice
    end)
    wrap Tr.configure(' ', '-')
    wrap Prefix.configure('Attention:')
    wrap Sufix.configure('!!!')
  end

decorated_string.make_it_fancy # Attention: ttHIS-iiS-aa-ttEST !!!
