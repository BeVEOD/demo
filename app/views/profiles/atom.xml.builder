
xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   _("Profiles")
  xml.link    "rel" => "self", "href" => url_for(:only_path => false, :controller => :profiles, :action => :feed, :format => :atom)
  xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :profiles, :action => :list)
  xml.id      url_for(:only_path => false, :controller => :profiles)
  
  xml.updated @profiles.first.new_date.strftime "%Y-%m-%dT%H:%M:%SZ" if @profiles.any? && @profiles.first.new_date
  
  xml.author  { xml.name "Faveod" }

  @profiles.each do |entry|
    xml.entry do
      xml.title   disp_name(entry)
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :profiles, :action => :show, :id => entry.id)
      xml.id      url_for(:only_path => false, :controller => :profiles, :action => :show, :id => entry.id)
  
      xml.updated ((entry.new_date || Time.now).strftime("%Y-%m-%dT%H:%M:%SZ"))
  
  
  
  
    end
  end
end
