module BaseHelper
  def included(receiver)
    if const_defined? :ExampleGroupMethods
      receiver.extend self::ExampleGroupMethods
    end

    if const_defined? :ExampleMethods
      receiver.send :include, self::ExampleMethods
    end
  end
end
