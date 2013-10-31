
xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0") {
  xml.channel {
    xml.title   _('App Locales')
    xml.link    url_for(:only_path => false)
#    xml.description("yourDescription")
    xml.language(GetText.locale.to_s)
    @app_locales.each do |entry|
      xml.item do
        xml.title entry.disp_name
    
    
        xml.pubDate(entry.updated_at.to_time.rfc2822) if entry.updated_at # rfc822
    
        xml.link(url_for(:only_path => false, :controller => :app_locales, :action => :show, :id => entry.id))
        xml.guid(url_for(:only_path => false, :controller => :app_locales, :action => :show, :id => entry.id))
      end
    end
  }
}
