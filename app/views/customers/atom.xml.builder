
xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   _("Customers")
  xml.link    "rel" => "self", "href" => url_for(:only_path => false, :controller => :customers, :action => :feed, :format => :atom)
  xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :customers, :action => :list)
  xml.id      url_for(:only_path => false, :controller => :customers)
  
  xml.updated @customers.first.new_date.strftime "%Y-%m-%dT%H:%M:%SZ" if @customers.any? && @customers.first.new_date
  
  xml.author  { xml.name "Faveod" }

  @customers.each do |entry|
    xml.entry do
      xml.title   entry.disp_name
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :customers, :action => :show, :id => entry.id)
      xml.id      url_for(:only_path => false, :controller => :customers, :action => :show, :id => entry.id)
  
      xml.updated ((entry.new_date || Time.now).strftime("%Y-%m-%dT%H:%M:%SZ"))
  
  
      xml.author  { xml.name(entry.user ? entry.user.disp_name : '') }
  
  
  
    end
  end
end
