
xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0") {
  xml.channel {
    xml.title   _('System Settings')
    xml.link    url_for(:only_path => false)
#    xml.description("yourDescription")
    xml.language(GetText.locale.to_s)
    @system_settings.each do |entry|
      xml.item do
        xml.title entry.disp_name
    
    
        xml.link(url_for(:only_path => false, :controller => :system_settings, :action => :show, :id => entry.id))
        xml.guid(url_for(:only_path => false, :controller => :system_settings, :action => :show, :id => entry.id))
      end
    end
  }
}
