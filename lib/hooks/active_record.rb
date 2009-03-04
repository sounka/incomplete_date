class IncompleteDate

  module ActiveRecord::ClassMethods

    #
    # Modifies the typecast so that it uses IncompleteDate instead of Date
    #
    def incomplete_date_attr(attr_name)
      instance_var = "@#{attr_name}"

      # getter
      define_method "#{attr_name}" do
        value = instance_variable_get(instance_var)
        value ||= IncompleteDate.parse(send("#{attr_name}_before_type_cast"))
        instance_variable_set(instance_var, value)
        value
      end

      # setter
      define_method "#{attr_name}=" do |value|
        value_s = value.to_s
        instance_variable_set(instance_var, value)
        write_attribute(attr_name, value_s)
      end
    end

    #
    # Defines several virtual attributes at once for raw real attributes
    #
    def incomplete_date_attrs(*names)
      options = names.extract_options!
      names.each do |name|
        incomplete_date_attr name
      end
    end

  end

end
