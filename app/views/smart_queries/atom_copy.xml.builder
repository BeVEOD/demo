xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   _("Smart Queries")
  xml.link    "rel" => "self", "href" => url_for(:only_path => false, :controller => :smart_queries, :action => :feed, :format => :atom)
  xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :smart_queries, :action => :list)
  xml.id      url_for(:only_path => false, :controller => :smart_queries)
  
  xml.author  { xml.name "Faveod" }

  @smart_queries.each do |entry|
    xml.entry do
      xml.title   entry.disp_name
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :smart_queries, :action => :show, :id => entry.id)
      xml.id      url_for(:only_path => false, :controller => :smart_queries, :action => :show, :id => entry.id)
  
  
  
  
    end
  end
end
