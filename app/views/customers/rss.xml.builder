
xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0") {
  xml.channel {
    xml.title   _('Customers')
    xml.link    url_for(:only_path => false)
#    xml.description("yourDescription")
    xml.language(GetText.locale.to_s)
    @customers.each do |entry|
      xml.item do
        xml.title entry.disp_name
    
    
        xml.pubDate(entry.new_date.to_time.rfc2822) if entry.new_date # rfc822
    
        xml.link(url_for(:only_path => false, :controller => :customers, :action => :show, :id => entry.id))
        xml.guid(url_for(:only_path => false, :controller => :customers, :action => :show, :id => entry.id))
      end
    end
  }
}
