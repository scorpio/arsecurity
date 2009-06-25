ActiveRecord::Base.class_eval do
  include ArsecurityDefault
  def self.rinter_skip?
    !YourContext.security_check
  end
  def rinter_skip?
    !YourContext.security_check
  end
end
def free_access(&block)
  old_security_check = YourContext.security_check
  YourContext.security_check = false
  result =  yield
  YourContext.security_check = old_security_check
  result
end
class YourSecurityHandler < DefaultArsecurityHandler
  class << self
    #override
    def accept?
      current_user && current_user.is_admin?
    end
    #override
    def reject?
      false
    end
    #override
    def permissions
      current_user && current_user.permissions
    end
    
    def current_user
      YourContext.your_user
    end
  end
end
ArsecurityUtil.handler = YourSecurityHandler
