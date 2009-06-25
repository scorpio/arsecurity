class ArsecurityUtil
  class << self
    attr_accessor :handler
    def authorized?(operation, target_class_name, instance, invocation)
      return true if handler.accept?
      return false if handler.reject?
      result = false
      permissions = handler.permissions
      
      unless permissions.nil? || permissions.empty?
        result = check_permissions(permissions, operation, target_class_name, instance, invocation)
      end
      result
    end

    def check_permissions(permissions, operation, target_class_name, instance, invocation)
      
      permissions.each do |permission|
        permission = ArsecurityPermission.new(permission) if permission.is_a?(Hash)
        next if permission.target_class_name != target_class_name
        if permission.operation.present?
          next if permission.operation != operation
        end
        #instance not nil mean persist
        
        unless instance.nil?
          if  permission.instance_condition.nil? || permission.instance_condition.empty?
            return true
          else
            result = ERB.new("<% result =  (#{permission.instance_condition}) ? true : false %><%= result %>").result(instance.send(:binding))
            return true if result == 'true'
          end
        else
          #singleton methods, mean has permission to do this action, but check if there is any restriction need be attached
          unless permission.sql_condition.nil? || permission.sql_condition.empty?
            conditions = handler.get_conditions(invocation)
            if conditions.nil? || conditions.empty?
              conditions = permission.sql_condition
            elsif conditions.is_a?(String)
              conditions = "(" << conditions << ") and (" << permission.sql_condition << ")"
            elsif conditions.is_a?(Array)
              conditions[0] = "(" << conditions[0] << ") and (" << permission.sql_condition << ")"
            elsif conditions.is_a?(Hash)
              new_conditions = []
              new_conditions[0] = ""
              conditions.each do |k, v|
                new_conditions[0] << " #{k} #{attribute_condition(v)}"
                if v.is_a?(Range)
                  new_conditions << v.first
                  new_conditions << v.last
                else
                  new_conditions << v
                end
              end
              conditions = new_conditions
              conditions[0] = "(" << conditions[0] << ") and (" << permission.sql_condition << ")"
            end
            handler.set_conditions(invocation, conditions)
          end
          return true
        end
      end
      false
    end 
    
    def has_permission(permission, operation, target_class_name, instance)
      return false if permission.target_class_name != target_class_name
      
      if permission.operation.present?
        return false if permission.operation != operation
      end
      
      if permission.instance_condition.blank?
        return true      
      else
        result = ERB.new("<% result =  (#{permission.instance_condition}) ? true : false %><%= result %>").result(instance.send(:binding))
        return result == 'true'
      end
    end
    
    def attribute_condition(argument)
      case argument
        when nil   then "IS ?"
        when Array, ActiveRecord::Associations::AssociationCollection then "IN (?)"
        when Range then "BETWEEN ? AND ?"
      else            "= ?"
      end
    end
  end
end
