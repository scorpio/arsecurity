require 'arsecurity'
require 'arsecurity_handler'
module ArsecurityDefault
  #value can be regexp, symbol or string
  CLASS_READ_METHOD = ["find_every", "count"]
  CLASS_DELETE_METHOD = "delete_all"
  CLASS_UPDATE_METHOD = "update_all"
  INSTANCE_CREATE = {:create => :create}
  INSTANCE_DELETE = {:delete => /^destroy$/}
  INSTANCE_UPDATE = {:update => :update}
  CLASS_READ = {:read => CLASS_READ_METHOD}
  CLASS_DELETE = {:delete => CLASS_DELETE_METHOD}
  CLASS_UPDATE = {:update => CLASS_UPDATE_METHOD}
  INCLUDE_I_METHODS = INSTANCE_CREATE.merge(INSTANCE_UPDATE).merge(INSTANCE_DELETE)
  INCLUDE_S_METHODS = CLASS_READ.merge(CLASS_UPDATE).merge(CLASS_DELETE)
  def self.rinter_before_include_class(base)
    base.instance_variable_set(:@include_i_methods, INCLUDE_I_METHODS)
    base.instance_variable_set(:@include_s_methods, INCLUDE_S_METHODS)
  end
  include Arsecurity
end

class DefaultArsecurityHandler < ArsecurityHandler
  class << self
    #for customize logic, such as for administrator
    def accept?
      false
    end
    #for customize logic, such as for time restriction
    def reject?
      false
    end
    def get_conditions(invocation)
      case invocation.method
        when *ArsecurityDefault::CLASS_READ_METHOD
        args = invocation.args || []
        options = args.extract_options!
        invocation.args = args
        invocation.options = options
        conditions = options[:conditions]
        when ArsecurityDefault::CLASS_DELETE_METHOD
        conditions = invocation.args[0]
        when ArsecurityDefault::CLASS_UPDATE_METHOD
        conditions = invocation.args[1]
      end
      conditions
    end
    
    def set_conditions(invocation, conditions)
      case invocation.method
        when *ArsecurityDefault::CLASS_READ_METHOD
        options = invocation.options
        options[:conditions] = conditions 
        when ArsecurityDefault::CLASS_DELETE_METHOD
        invocation.args[0] = conditions 
        when ArsecurityDefault::CLASS_UPDATE_METHOD
        invocation.args[1] = conditions
      end
    end
  end
end