if Object.const_defined?('FastGettext')
  Object.send(:include, FastGettext::Translation)
  ActiveRecord::Base.send(:include, FastGettext::Translation)

  Dir[Rails.root.join('locale', '**/*.mo')].map{ |td|
    td.split('/').last.sub(/\.mo/, '')
  }.uniq.each { |text_domain|
    FastGettext.add_text_domain(text_domain, :path => Rails.root.join('locale'))
  }
  FastGettext.available_locales = Dir[Rails.root.join('locale', '*')].map { |l| l.split('/').last }

  if Rails.version =~ /\A2\./
    FastGettext.default_text_domain = APP_SID
  else
    FastGettext.default_text_domain = Rails.application.class.parent_name.tableize.singularize.sub(/_app/, '')
  end
  FastGettext.locale = 'en'


#  Dir[Rails.root.join("locale", '*', 'LC_MESSAGES', "*.mo")].map do |f| 
#    td = f.split('/').last.sub(/\.mo/, '')
#    FastGettext.add_text_domain(td, :path => Rails.root.join('locale'))
#    FastGettext.text_domain = td
#  end

  module GetText
    def self.locale
      FastGettext.locale
    end

    def self.locale=(l)
      FastGettext.set_locale(l)
    end
  end
end
