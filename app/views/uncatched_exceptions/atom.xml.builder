
xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   _("Uncatched Exceptions")
  xml.link    "rel" => "self", "href" => url_for(:only_path => false, :controller => :uncatched_exceptions, :action => :feed, :format => :atom)
  xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :uncatched_exceptions, :action => :list)
  xml.id      url_for(:only_path => false, :controller => :uncatched_exceptions)
  
  xml.updated @uncatched_exceptions.first.created_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @uncatched_exceptions.any? && @uncatched_exceptions.first.created_at
  
  xml.author  { xml.name "Faveod" }

  @uncatched_exceptions.each do |entry|
    xml.entry do
      xml.title   entry.disp_name
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :uncatched_exceptions, :action => :show, :id => entry.id)
      xml.id      url_for(:only_path => false, :controller => :uncatched_exceptions, :action => :show, :id => entry.id)
  
      xml.updated ((entry.created_at || Time.now).strftime("%Y-%m-%dT%H:%M:%SZ"))
  
  
  
  
    end
  end
end
