
xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   _("App Locales")
  xml.link    "rel" => "self", "href" => url_for(:only_path => false, :controller => :app_locales, :action => :feed, :format => :atom)
  xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :app_locales, :action => :list)
  xml.id      url_for(:only_path => false, :controller => :app_locales)
  
  xml.updated @app_locales.first.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @app_locales.any? && @app_locales.first.updated_at
  
  xml.author  { xml.name "Faveod" }

  @app_locales.each do |entry|
    xml.entry do
      xml.title   entry.disp_name
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => :app_locales, :action => :show, :id => entry.id)
      xml.id      url_for(:only_path => false, :controller => :app_locales, :action => :show, :id => entry.id)
  
      xml.updated ((entry.updated_at || Time.now).strftime("%Y-%m-%dT%H:%M:%SZ"))
  
  
  
  
    end
  end
end
