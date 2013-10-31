
xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   _("File Imports")
  xml.link    "rel" => "self", "href" => url_for(:only_path => false, :controller => :file_imports, :action => :feed, :format => :atom)
  xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :file_imports, :action => :list)
  xml.id      url_for(:only_path => false, :controller => :file_imports)
  
  xml.updated @file_imports.first.started_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @file_imports.any? && @file_imports.first.started_at
  
  xml.author  { xml.name "Faveod" }

  @file_imports.each do |entry|
    xml.entry do
      xml.title   entry.disp_name
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :file_imports, :action => :show, :id => entry.id)
      xml.id      url_for(:only_path => false, :controller => :file_imports, :action => :show, :id => entry.id)
  
      xml.updated ((entry.started_at || Time.now).strftime("%Y-%m-%dT%H:%M:%SZ"))
  
  
      xml.author  { xml.name(entry.user ? entry.user.disp_name : '') }
  
  
  
    end
  end
end
