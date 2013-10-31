xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   _("System Settings")
  xml.link    "rel" => "self", "href" => url_for(:only_path => false, :controller => :system_settings, :action => :feed, :format => :atom)
  xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :system_settings, :action => :list)
  xml.id      url_for(:only_path => false, :controller => :system_settings)
  
  xml.author  { xml.name "Faveod" }

  @system_settings.each do |entry|
    xml.entry do
      xml.title   entry.disp_name
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :system_settings, :action => :show, :id => entry.id)
      xml.id      url_for(:only_path => false, :controller => :system_settings, :action => :show, :id => entry.id)
  
  
  
  
    end
  end
end
