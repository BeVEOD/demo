module DefaultFinder
  module Finder
    def self.included(base)
      base.extend ClassMethods
      class << base
        alias_method_chain :find, :default_options
      end
    end
    
    module ClassMethods
      def default_find_option(option_name, value)
        @default_find_options ||= {}
        @default_find_options[option_name] = value
      end
      
      def find_with_default_options(*args)
        if !@default_find_options.nil?
          with_scope(:find => @default_find_options) do
            find_without_default_options(*args)
          end
        else
          find_without_default_options(*args)
        end
      end
    end
  end
end
ActiveRecord::Base.send :include, DefaultFinder::Finder
