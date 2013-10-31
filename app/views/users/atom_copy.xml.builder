xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   _("Users")
  xml.link    "rel" => "self", "href" => url_for(:only_path => false, :controller => :users, :action => :feed, :format => :atom)
  xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :users, :action => :list)
  xml.id      url_for(:only_path => false, :controller => :users)
  
  xml.updated @users.first.last_login.strftime "%Y-%m-%dT%H:%M:%SZ" if @users.any? && @users.first.last_login
  
  xml.author  { xml.name "Faveod" }

  @users.each do |entry|
    xml.entry do
      xml.title   entry.disp_name
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :users, :action => :show, :id => entry.id)
      xml.id      url_for(:only_path => false, :controller => :users, :action => :show, :id => entry.id)
  
      xml.updated ((entry.last_login || Time.now).strftime("%Y-%m-%dT%H:%M:%SZ"))
  
  
  
  
    end
  end
end
