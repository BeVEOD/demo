module ActiveRecord

class Condition
  attr_reader :args

  def self.block(&block)
    new(&block).where
  end

  def initialize
    @args = []
    @logic = " AND "
    yield self if block_given?
  end

  def and(*args, &block)
    if block_given?
      block(&block)
    else
      @logic = " AND "
      @args << args
    end
  end
  alias :add :and

  def or(*args, &block)
    if block_given?
      block(&block)
    else
      @logic = " OR "
      @args << args
    end
  end

  def block(&block)
    @args << self.class.new(&block)
  end

  def where(conditions = @args)
    return nil if conditions.empty?
    # Build the condition string with ?s using the 'left' array, and
    # build the value string using the 'right' array:
    left, right = [], []
    conditions.each do |column, *values|
      values = [values] unless values.is_a? Array

      if (sub_condition = column).is_a? Condition
        # Integrate the sub-condition
        sub_sql, *sub_values = sub_condition.where
        left << "(" + sub_sql + ")"
        right += sub_values
        next
      elsif column.to_s.downcase == "sql"
        # Treat the first 'value' as pure SQL
        left << values.shift
        next
      end

      case values.size
      when 0
        raise "No value specified for Condition"
      when 1
        if values.last.is_a?(Array)
          left << "#{column} IN (?)"
        else
          left << "#{column} = ?"
        end
        right << values.last
      when 2
        op = operator = values.shift
        operator = 'LIKE' if operator == '=~'
        operator = 'NOT LIKE' if operator == '!=~'
        if values.last.is_a?(Array)
          left << "#{column} IN (?)"
        else
          left << "#{column} #{operator} ?"
        end
        right << ((op == '=~' || op == '!=~') ? "%#{values.last}%" : values.last)
      else
        operator = values.first
        if operator.upcase == "BETWEEN"
          left << "#{column} #{operator} ? AND ?"
          right << values[-2] << values[-1]
        else
          raise "Unknown operator for multiple values in Condition: #{operator}"
        end
      end
    end
    return [left.join(@logic)].concat(right)
  end
end
end
