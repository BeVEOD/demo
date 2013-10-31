
xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0") {
  xml.channel {
    xml.title   _('Dev Feedbacks')
    xml.link    url_for(:only_path => false)
#    xml.description("yourDescription")
    xml.language(GetText.locale.to_s)
    @dev_feedbacks.each do |entry|
      xml.item do
        xml.title entry.disp_name
    
    
        xml.pubDate(entry.created_at.to_time.rfc2822) if entry.created_at # rfc822
    
        xml.link(url_for(:only_path => false, :controller => :dev_feedbacks, :action => :show, :id => entry.id))
        xml.guid(url_for(:only_path => false, :controller => :dev_feedbacks, :action => :show, :id => entry.id))
      end
    end
  }
}
