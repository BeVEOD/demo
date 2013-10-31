ActiveRecord::Validations::ClassMethods.class_eval do

def validates_uniqueness_of_static_list(*attr_names)
  configuration = { :case_sensitive => true }
  configuration.update(attr_names.extract_options!)
  
  validates_each(attr_names,configuration) do |record, attr_name, value|
        
    value = record.read_attribute(attr_name)
        
    class_hierarchy = [record.class]
    while class_hierarchy.first != self
      class_hierarchy.insert(0, class_hierarchy.first.superclass)
    end
    
    # Now we can work our way down the tree to the first non-abstract
    # class (which has a database table to query from).
    finder_class = class_hierarchy.detect { |klass| !klass.abstract_class? }
    
    is_text_column = false
    
    if value.nil?
      comparison_operator = "IS ?"
    else
      comparison_operator = "= ?"
    end
    
    sql_attribute = "#{record.class.quoted_table_name}.#{connection.quote_column_name(attr_name)}"
    
    if value.nil? || (configuration[:case_sensitive] || !is_text_column)
      condition_sql = "#{sql_attribute} #{comparison_operator}"
      condition_params = [value]
    else
      condition_sql = "LOWER(#{sql_attribute}) #{comparison_operator}"
      condition_params = [value.mb_chars.downcase]
    end
    
    if scope = configuration[:scope]
      Array(scope).map do |scope_item|
        scope_value = record.send(scope_item)
        condition_sql << " AND #{record.class.quoted_table_name}.#{scope_item} #{attribute_condition(scope_value)}"
        condition_params << scope_value
      end
    end
    
    unless record.new_record?
      condition_sql << " AND #{record.class.quoted_table_name}.#{record.class.primary_key} <> ?"
      condition_params << record.send(:id)
    end
    
    finder_class.with_exclusive_scope do
      if finder_class.exists?([condition_sql, *condition_params])
        record.errors.add(attr_name, configuration[:message])
      end
    end
  end
end

end
