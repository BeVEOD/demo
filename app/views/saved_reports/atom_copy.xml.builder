xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   _("Saved Reports")
  xml.link    "rel" => "self", "href" => url_for(:only_path => false, :controller => :saved_reports, :action => :feed, :format => :atom)
  xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :saved_reports, :action => :list)
  xml.id      url_for(:only_path => false, :controller => :saved_reports)
  
  xml.updated @saved_reports.first.created_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @saved_reports.any? && @saved_reports.first.created_at
  
  xml.author  { xml.name "Faveod" }

  @saved_reports.each do |entry|
    xml.entry do
      xml.title   entry.disp_name
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :saved_reports, :action => :show, :id => entry.id)
      xml.id      url_for(:only_path => false, :controller => :saved_reports, :action => :show, :id => entry.id)
  
      xml.updated ((entry.created_at || Time.now).strftime("%Y-%m-%dT%H:%M:%SZ"))
  
  
  
  
    end
  end
end
