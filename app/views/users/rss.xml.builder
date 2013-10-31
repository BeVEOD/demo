
xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0") {
  xml.channel {
    xml.title   _('Users')
    xml.link    url_for(:only_path => false)
#    xml.description("yourDescription")
    xml.language(GetText.locale.to_s)
    @users.each do |entry|
      xml.item do
        xml.title entry.disp_name
    
    
        xml.pubDate(entry.last_login.to_time.rfc2822) if entry.last_login # rfc822
    
        xml.link(url_for(:only_path => false, :controller => :users, :action => :show, :id => entry.id))
        xml.guid(url_for(:only_path => false, :controller => :users, :action => :show, :id => entry.id))
      end
    end
  }
}
