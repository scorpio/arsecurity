class ArsecurityPermission
  attr_accessor :target_class_name, :operation, :instance_condition, :sql_condition
  def initialize(permission)
    @target_class_name = permission[:target_class_name]
    @operation = permission[:operation]
    @instance_condition = permission[:instance_condition]
    @sql_condition = permission[:sql_condition]
  end
end
