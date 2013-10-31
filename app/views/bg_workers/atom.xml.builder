
xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   _("Bg Workers")
  xml.link    "rel" => "self", "href" => url_for(:only_path => false, :controller => :bg_workers, :action => :feed, :format => :atom)
  xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :bg_workers, :action => :list)
  xml.id      url_for(:only_path => false, :controller => :bg_workers)
  
  xml.updated @bg_workers.first.from.strftime "%Y-%m-%dT%H:%M:%SZ" if @bg_workers.any? && @bg_workers.first.from
  
  xml.author  { xml.name "Faveod" }

  @bg_workers.each do |entry|
    xml.entry do
      xml.title   entry.disp_name
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :bg_workers, :action => :show, :id => entry.id)
      xml.id      url_for(:only_path => false, :controller => :bg_workers, :action => :show, :id => entry.id)
  
      xml.updated ((entry.from || Time.now).strftime("%Y-%m-%dT%H:%M:%SZ"))
  
  
  
  
    end
  end
end
