require 'rinterceptor'
require 'arsecurity_util'
module Arsecurity
  CREATE = 'create'
  READ = 'read'
  UPDATE = 'update'
  DELETE = 'delete'
  def rinter_update_around(invocation)
    if ArsecurityUtil.authorized?(UPDATE, invocation.object.class.name, invocation.object, invocation)
      return invocation.invoke
    else
      raise ArsecurityNotAuthorizedException
    end
  end
  def rinter_create_around(invocation)
    if ArsecurityUtil.authorized?(CREATE, invocation.object.class.name, invocation.object, invocation)
      return invocation.invoke
    else
      raise ArsecurityNotAuthorizedException
    end
  end
  def rinter_delete_around(invocation)
    if ArsecurityUtil.authorized?(DELETE, invocation.object.class.name, invocation.object, invocation)
      return invocation.invoke
    else
      raise ArsecurityNotAuthorizedException
    end
  end
  module ClassMethods
    def rinter_update_around(invocation)
      if ArsecurityUtil.authorized?(UPDATE, invocation.object.name, nil, invocation)
        return invocation.invoke
      else
        raise ArsecurityNotAuthorizedException
      end
    end
    def rinter_read_around(invocation)
      if ArsecurityUtil.authorized?(READ, invocation.object.name, nil, invocation)
        return invocation.invoke
      else
        raise ArsecurityNotAuthorizedException
      end
    end
    def rinter_delete_around(invocation)
      if ArsecurityUtil.authorized?(DELETE, invocation.object.name, nil, invocation)
        return invocation.invoke
      else
        raise ArsecurityNotAuthorizedException
      end
    end
  end
  include Rinterceptor
end

class ArsecurityNotAuthorizedException < RuntimeError
end

class ArsecurityIllegalException < RuntimeError
end