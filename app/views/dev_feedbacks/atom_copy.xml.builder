xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   _("Dev Feedbacks")
  xml.link    "rel" => "self", "href" => url_for(:only_path => false, :controller => :dev_feedbacks, :action => :feed, :format => :atom)
  xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :dev_feedbacks, :action => :list)
  xml.id      url_for(:only_path => false, :controller => :dev_feedbacks)
  
  xml.updated @dev_feedbacks.first.created_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @dev_feedbacks.any? && @dev_feedbacks.first.created_at
  
  xml.author  { xml.name "Faveod" }

  @dev_feedbacks.each do |entry|
    xml.entry do
      xml.title   entry.disp_name
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :dev_feedbacks, :action => :show, :id => entry.id)
      xml.id      url_for(:only_path => false, :controller => :dev_feedbacks, :action => :show, :id => entry.id)
  
      xml.updated ((entry.created_at || Time.now).strftime("%Y-%m-%dT%H:%M:%SZ"))
  
  
      xml.author  { xml.name(entry.user ? entry.user.disp_name : '') }
  
  
  
    end
  end
end
