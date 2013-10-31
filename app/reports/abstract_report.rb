# -*- encoding : utf-8 -*-
class AbstractReport
  if Object.const_defined?('FastGettext')
    include FastGettext::Translation
  else
    include GetText
  end
  include ActionView::Helpers::NumberHelper
  attr_accessor(:format)
  attr_accessor(:data)
  attr_accessor(:options)

  def initialize(f=nil, opts={})
    @format = f || :json
    @format = @format.to_sym
    @options = opts.clone
    @data = {:elements => []}
  end

  def self.make_report(rep, opts={})
    self.new(opts[:format], opts).make_report(rep)
  end

  def make_report(rep)
    case self.format
    when :html
      self.send("report_#{rep}_html")

      #    when :xml

    when :json
      self.send("report_#{rep}_json")
    end
  end
end
