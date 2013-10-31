
xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0") {
  xml.channel {
    xml.title   _('Profiles')
    xml.link    url_for(:only_path => false)
#    xml.description("yourDescription")
    xml.language(GetText.locale.to_s)
    @profiles.each do |entry|
      xml.item do
        xml.title   disp_name(entry)
    
    
        xml.link(url_for(:only_path => false, :controller => :profiles, :action => :show, :id => entry.id))
        xml.guid(url_for(:only_path => false, :controller => :profiles, :action => :show, :id => entry.id))
      end
    end
  }
}
