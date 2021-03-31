# @TODO understant how the fuck it work ><
InterfaceError = Class.new Exception
 
class Class
  def interface mod
    interface_tracer = TracePoint.new(:end) { |t|
      if t.self == self
        check_interface self, mod
        interface_tracer.disable
      end
    }.tap &:enable
  end
 
  private def check_interface kls, mod
    mod.instance_methods.each do |m|
      unless instance_methods.include? m
        raise InterfaceError, "#{m} not implemented}"
      end
      unless mod.instance_method(m).arity == instance_method(m).arity
        raise InterfaceError, "arity mismatch for #{m}"
      end
    end
  end
end
 
module Indexable
  def [] index
  end
 
  def []= index, value
  end
end
 
class C
  interface Indexable
 
  def [] index
  end
 
  def []= other
  end
end
