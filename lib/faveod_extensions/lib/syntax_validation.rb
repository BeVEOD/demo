require "open3"
require "erb"

module Faveod
module Validations
module Syntax

  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end

  module ClassMethods
    def check_ruby_syntax(code)
      return :OK if code.blank?
      errors = Open3.popen3("RUBYOPT='' ruby -c") do |stdin, stdout, stderr|
        stdin.write(code)
        stdin.close
        stderr.read
      end
      return errors.empty? ? :OK : errors
    end

    def valid_ruby_syntax?(code)
      check_ruby_syntax(code) == :OK
    end

    def check_erb_syntax(code)
      return :OK if code.blank?
      check_ruby_syntax(ERB.new(code).src)
    end

    def valid_erb_syntax?(code)
      check_erb_syntax(code) == :OK
    end

    # check erb and ruby result
    # can not be right if complex template
#    def check_rerb_syntax(code)
#      return :OK if code.nil?
#      src = check_erb_syntax(code)
#      return src unless src == :OK
#      return check_ruby_syntax(code.gsub(/<%.*%>/, 'placeholder'))
#    end

#    def valid_rerb_syntax?(code)
#      check_rerb_syntax(code) == :OK
#    end

  end

end
end
end


ActiveRecord::Validations::ClassMethods.class_eval do

  def validates_ruby_syntax_of(*attr_names)
    configuration = { :message => "is no valid Ruby syntax", :on => :save }
    configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

    validates_each(attr_names, configuration) do |record, attr_name, value|
      record.errors.add(attr_name, configuration[:message] + " (#{check_ruby_syntax(value)})") unless valid_ruby_syntax?(value)
    end
  end

  def validates_erb_syntax_of(*attr_names)
    configuration = { :message => "is no valid ERB syntax", :on => :save }
    configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

    validates_each(attr_names, configuration) do |record, attr_name, value|
      record.errors.add(attr_name, configuration[:message] + " (#{check_erb_syntax(value)})") unless valid_erb_syntax?(value)
    end
  end

#  def validates_rerb_syntax_of(*attr_names)
#    configuration = { :message => "is no valid Ruby ERB syntax", :on => :save }
#    configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

#    validates_each(attr_names, configuration) do |record, attr_name, value|
#      record.errors.add(attr_name, configuration[:message] + " (#{check_rerb_syntax(value)})") unless valid_rerb_syntax?(value)
#    end
#  end

end
