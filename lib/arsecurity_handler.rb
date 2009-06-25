class ArsecurityHandler
  class << self
    #for customize logic, such as for administrator
    def accept?
      raise ArsecurityIllegalException.new("ArsecurityHandler.accept? should be implemented")
    end
    #for customize logic, such as for time restriction
    def reject?
      raise ArsecurityIllegalException.new("ArsecurityHandler.reject? should be implemented")
    end
    def permissions
      raise ArsecurityIllegalException.new("ArsecurityHandler.permissions should be implemented")
    end
    
    #for changing conditions
    def get_conditions(invocation)
      raise ArsecurityIllegalException.new("ArsecurityHandler.get_conditions should be implemented")
    end
    
    def set_conditions(invocation, conditions)
      raise ArsecurityIllegalException.new("ArsecurityHandler.set_conditions should be implemented")
    end
  end
end
