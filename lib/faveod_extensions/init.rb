require 'condition'
require 'graph_maker'
require 'ar_extensions'
require 'syntax_validation'
require 'static_list_validation'
# require 'thumbnailer'
require 'chart_builder'
require 'po_parser'

#require 'default_finder'

require 'form_options_helper'
require 'ajax_will_paginate'
require 'html_truncator'
# require 'ie_pdf_headers_middleware'
require 'distributed_colors'

require 'activeresource_extensions'

#require 'translation_services'
#require 'translation_services_helper'

#require 'better_nested_set_helper'

require 'rbeautify'

#ActionView::Base.send(:include, Faveod::TranslationServicesHelper)
#ActionView::Base.send(:include, Faveod::HtmlTruncator)
#ActionView::Base.send :include, SymetrieCom::Acts::BetterNestedSetHelper

ActionController::Base.send(:include, Thumbnailer)
ActionController::Base.send(:include, Faveod::GraphMaker)
AbstractReport.send(:include, Faveod::DistributedColors)


ActiveRecord::Base.class_eval do
  include Faveod::Validations::Syntax

#  def _(str)
#    str
#  end
end

#ActiveResource::Base.send(:include, Faveod::ActiveResourceExtensions)
if RAILS_GEM_VERSION < '3.0'
ActiveResource::Base.class_eval do
  include WillPaginate::Finder if defined?(WillPaginate)
  class << self
    include Faveod::ActiveResourceExtensions::ClassMethods
  end
end
end


FAVEOD_DATE_FORMATS = {:european => '%d/%m/%Y', :sort => '%Y-%m-%d'}
FAVEOD_TIME_FORMATS = {:hyphen_ampm => '%Y-%m-%d %H:%M %p', :european => '%d/%m/%Y %H:%M'}
if RAILS_GEM_VERSION < '3.0'
  ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.update(FAVEOD_DATE_FORMATS)
  ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.update(FAVEOD_TIME_FORMATS)
else
  Date::DATE_FORMATS.update(FAVEOD_DATE_FORMATS)
  Time::DATE_FORMATS.update(FAVEOD_TIME_FORMATS)
end

if Rails.version >= '3.1'
 class PdfHandler 
  def self.call(template)
    new.compile(template)
  end
  
  def compile(template)
    <<-PDF
  if !self.respond_to?(:make_pdf)
    render :text => 'Please Add "make_pdf" to manage PDF generation'
  end
  options ||= {}
  self.content_type ||= Mime::Type.lookup(:pdf)
  fname = options[:filename] ? options.delete(:filename) : "#{self.action_name}.pdf"
  ftype = options[:type] ? options.delete(:type) : "application/pdf"
  p = self.make_pdf(options.reject{|k,v| ![:action, :layout].include?(k) })
  send_data(p, :filename => fname, :type => ftype) unless @debug_pdf || p.blank? 
    PDF
  end
 end
 ::ActionView::Template.register_template_handler(:pdf, PdfHandler)
elsif Rails.version >= '3'
 ActionController::Renderers.add :pdf do |obj, options|  
  if !self.respond_to?(:make_pdf)
    render :text => 'Please Add "make_pdf" to manage PDF generation'
  end
  options ||= {}
  self.content_type ||= Mime::Type.lookup(:pdf)
  fname = options[:filename] ? options.delete(:filename) : "#{self.action_name}.pdf"
  ftype = options[:type] ? options.delete(:type) : "application/pdf"
  p = self.make_pdf(options.reject{|k,v| ![:action, :layout].include?(k) })
  send_data(p, :filename => fname, :type => ftype) unless @debug_pdf || p.blank? 
 end
end

::LOCALIZED_DATE     = {'fr' => {:list => :european, :show => :european, :edit => :european},
                        'en' => {:list => :short, :show => :long, :edit => :db}}
::LOCALIZED_TIME     = {'fr' => {:list => :european, :show => :european, :edit => :european},
                        'en' => {:list => :short, :show => :long, :edit => :db}}
::LOCALIZED_DATETIME = {'fr' => {:list => :european, :show => :european, :edit => :european},
                        'en' => {:list => :short, :show => :long, :edit => :db}}

String.class_eval do
  def to_permalink
    if RUBY_VERSION =~ /^1\.8/ # Ruby 1.8 code
      Iconv.new('US-ASCII//TRANSLIT', 'utf-8').iconv(self).gsub(/[^\w\s\-]/,'').gsub(/[^\w]|[\_]/,' ').split.join('-').downcase
    else
      self.encode("utf-8").gsub(/[^\w\s\-]/,'').gsub(/[^\w]|[\_]/,' ').split.join('-').downcase
    end
  end
end

begin
 require 'faveod_code_writer'
rescue Exception => e
 nil
end


