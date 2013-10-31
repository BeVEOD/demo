module ActiveRecord

  class << Base
    alias_method :[], :find
  end

  class Base
    def params_to_attributes(params)
      return if params.nil?
      att = params.dup.stringify_keys!

      multi_parameter_attributes = []
      att.each do |k, v|
        if k.include?("(")
          att.delete(k)
          multi_parameter_attributes << [ k, v ]
        end
      end

      cs = extract_callstack_for_multiparameter_attributes(multi_parameter_attributes)
      return att.merge(get_multiparameter_attributes(cs))
    end

    def get_multiparameter_attributes(callstack)
      errors = []
      att = {}
      callstack.each do |name, values|
        klass = (self.class.reflect_on_aggregation(name.to_sym) || column_for_attribute(name)).klass
        if values.empty?
          att[name] = nil
        else
          begin
            att[name] = (Time == klass ? (@@default_timezone == :utc ? klass.utc(*values) : klass.local(*values)) : klass.new(*values))
          rescue => ex
            errors << AttributeAssignmentError.new("error on assignment #{values.inspect} to #{name}", ex, name)
          end
        end
      end
      unless errors.empty?
        raise MultiparameterAssignmentErrors.new(errors), "#{errors.size} error(s) on assignment of multiparameter attributes"
      end
      return att
    end
  end
end
