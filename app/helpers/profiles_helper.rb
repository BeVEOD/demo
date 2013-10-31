# encoding: utf-8
################################################
## This file and all its content belong to Faveod S.A.S unless a commercial
## contract signed by a representant of Faveod S.A.S states otherwise.
##########
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
################################################
## This has been generated by Faveod Generator on Thu Oct 31 16:40:24 +0100 2013
## It should be placed at 'app/helpers/profiles_helper.rb'
## All manual modifications will be destroyed on next generation
################################################


module ProfilesHelper


  # Generally used for list actions.
  #
  # Author:: Yann Azoury
  # Version:: 12
  # Last Update:: 2013-01-29 23:35:49 UTC
  # Status:: Validation Pending


  def links_for_list_element(row, opts={})
    return "" if @no_row_links
    html = []
    if @pres_mode == :list_zoom
      html << link_to_remote(image_tag('std/show.png', :title => _('Show')),
      :url => {:controller => :profiles, :action => :show, :id => row.id},
      :update => "profiles_element")
      html << link_to_remote(image_tag('std/edit.png', :title => _('Edit')),
      :url => {:controller => :profiles, :action => :edit, :id => row.id},
      :update => "profiles_element")
    else
      html << if @pres_mode == :list_zoom
        %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('profiles_element', '#{ "/#{params[:lang]}" if params[:lang] }/profiles/show/#{ row.id }', {asynchronous:true, evalScripts:true});location.href='#profiles_element'; return false;" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/show.png" alt="#{ _(%q{Show}) }" title="#{ _(%q{Show}) }" /></a>}
      else
        %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/profiles/show/#{ row.id }" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/show.png" alt="#{ _(%q{Show}) }" title="#{ _(%q{Show}) }" /></a>}
      end
      html << if @pres_mode == :list_zoom
        %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('profiles_element', '#{ "/#{params[:lang]}" if params[:lang] }/profiles/edit/#{ row.id }', {asynchronous:true, evalScripts:true});location.href='#profiles_element'; return false;" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/page_icons/page_white_paintbrush.png" alt="#{ _(%q{Edit}) }" title="#{ _(%q{Edit}) }" /></a>}
      else
        %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/profiles/edit/#{ row.id }" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/page_icons/page_white_paintbrush.png" alt="#{ _(%q{Edit}) }" title="#{ _(%q{Edit}) }" /></a>}
      end
      html << nil
    end
    html << if @pres_mode == :list_zoom
      %Q{<a href="#" data-confirm="#{ _('Do you really want to delete %{record}?') %
      {:record => @profile.disp_name} }" data-method="post" onclick="new Ajax.Updater('profiles_element', '#{ "/#{params[:lang]}" if params[:lang] }/profiles/destroy/#{ @profile.id }', {asynchronous:true, evalScripts:true});location.href='#profiles_element'; return false;" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /></a>}
    else
      %Q{<a data-confirm="#{ _('Do you really want to delete %{record}?') %
      {:record => @profile.disp_name} }" data-method="post" href="#{ "/#{params[:lang]}" if params[:lang] }/profiles/destroy/#{ @profile.id }" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /></a>}
    end
    return html.compact.join(' | ').html_safe
  end


  # Author:: Sylvain Abélard
  # Version:: 17
  # Last Update:: 2013-03-19 15:06:38 UTC
  # Status:: Validation Pending


  def bottom_links_for_show(opts={})

    links = []
    if request.xhr?
      links << link_to_remote(image_tag('std/edit.png', :title => _("Edit")), :update => 'profiles_element', :url => {:action => :edit, :id => @profile, :version => params[:version]})
    else
      links << if @pres_mode == :list_zoom
        %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('profiles_element', '#{ "/#{params[:lang]}" if params[:lang] }/profiles/edit/#{ @profile.id }', {asynchronous:true, evalScripts:true});location.href='#profiles_element'; return false;" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/page_icons/page_white_paintbrush.png" alt="#{ _(%q{Edit}) }" title="#{ _(%q{Edit}) }" /> #{ _(%q{Edit}) }</a>}
      else
        %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/profiles/edit/#{ @profile.id }" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/page_icons/page_white_paintbrush.png" alt="#{ _(%q{Edit}) }" title="#{ _(%q{Edit}) }" /> #{ _(%q{Edit}) }</a>}
      end
    end
    links << if @pres_mode == :list_zoom
      %Q{<a href="#" data-confirm="#{ _('Do you really want to delete %{record}?') % {:record => @profile.disp_name} }" data-method="post" onclick="new Ajax.Updater('profiles_element', '#{ "/#{params[:lang]}" if params[:lang] }/profiles/destroy/#{ @profile.id }', {asynchronous:true, evalScripts:true});location.href='#profiles_element'; return false;" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /> #{ _(%q{Destroy}) }</a>}
    else
      %Q{<a data-confirm="#{ _('Do you really want to delete %{record}?') % {:record => @profile.disp_name} }" data-method="post" href="#{ "/#{params[:lang]}" if params[:lang] }/profiles/destroy/#{ @profile.id }" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /> #{ _(%q{Destroy}) }</a>}
    end
    links << if @pres_mode == :list_zoom
      %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('profiles_element', '#{ "/#{params[:lang]}" if params[:lang] }/profiles/index', {asynchronous:true, evalScripts:true});location.href='#profiles_element'; return false;" rel="nofollow" title="#{ _(%q{Index of all profiles.}) }"><img src="/images/page_icons/award_star_gold_3.png" alt="#{ _(%q{Profiles}) }" title="#{ _(%q{Profiles}) }"/> #{ _(%q{Profiles}) }</a>}
    else
      %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/profiles/index" rel="nofollow" title="#{ _(%q{Index of all profiles.}) }"><img src="/images/page_icons/award_star_gold_3.png" alt="#{ _(%q{Profiles}) }" title="#{ _(%q{Profiles}) }"/> #{ _(%q{Profiles}) }</a>}
    end
    unless opts[:no_sibling]
      prev = Profile.first(:select => '`profiles`.id', :conditions => ["`profiles`.id < ?", @profile.id], :order => '`profiles`.id DESC')
      nex = Profile.first(:select => '`profiles`.id', :conditions => ["`profiles`.id > ?", @profile.id], :order => '`profiles`.id')
      if request.xhr?
        links << link_to_remote(image_tag('std/go_left.png', :title => _("Previous")), :update => 'profiles_element', :url => {:action => :show, :id => prev.id}) if prev
        links << link_to_remote(image_tag('std/go_right.png', :title => _("Next")), :update => 'profiles_element', :url => {:action => :show, :id => nex.id}) if nex
      else
        if prev
          links << if @pres_mode == :list_zoom
            %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('profiles_element', '#{ "/#{params[:lang]}" if params[:lang] }/profiles/show/#{ prev.id }', {asynchronous:true, evalScripts:true});location.href='#profiles_element'; return false;" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/go_left.png" alt="#{ _(%q{Previous}) }" title="#{ _(%q{Previous}) }"/></a>}
          else
            %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/profiles/show/#{ prev.id }" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/go_left.png" alt="#{ _(%q{Previous}) }" title="#{ _(%q{Previous}) }"/></a>}
          end
        end
        if nex
          links << if @pres_mode == :list_zoom
            %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('profiles_element', '#{ "/#{params[:lang]}" if params[:lang] }/profiles/show/#{ nex.id }', {asynchronous:true, evalScripts:true});location.href='#profiles_element'; return false;" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/go_right.png" alt="#{ _(%q{Next}) }" title="#{ _(%q{Next}) }"/></a>}
          else
            %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/profiles/show/#{ nex.id }" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/go_right.png" alt="#{ _(%q{Next}) }" title="#{ _(%q{Next}) }"/></a>}
          end
        end
      end
    end
    return content_tag(:span, links.compact.join(' | ').html_safe, :class => 'std_links')
  end


  # Author:: Sylvain Abélard
  # Version:: 17
  # Last Update:: 2013-03-19 15:06:52 UTC
  # Status:: Validation Pending


  def bottom_links_for_edit(opts={})

    links = []
    if request.xhr?
      links << link_to_remote(image_tag('std/show.png', :title => _('Show')), :update => 'profiles_element', :url => {:action => :show, :id => @profile, :version => params[:version]})
    else
      links << if @pres_mode == :list_zoom
        %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('profiles_element', '#{ "/#{params[:lang]}" if params[:lang] }/profiles/show/#{ @profile.id }', {asynchronous:true, evalScripts:true});location.href='#profiles_element'; return false;" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/show.png" alt="#{ _(%q{Show}) }" title="#{ _(%q{Show}) }" /> #{ _(%q{Show}) }</a>}
      else
        %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/profiles/show/#{ @profile.id }" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/show.png" alt="#{ _(%q{Show}) }" title="#{ _(%q{Show}) }" /> #{ _(%q{Show}) }</a>}
      end
    end
    links << if @pres_mode == :list_zoom
      %Q{<a href="#" data-confirm="#{ _('Do you really want to delete %{record}?') % {:record => @profile.disp_name} }" data-method="post" onclick="new Ajax.Updater('profiles_element', '#{ "/#{params[:lang]}" if params[:lang] }/profiles/destroy/#{ @profile.id }', {asynchronous:true, evalScripts:true});location.href='#profiles_element'; return false;" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /> #{ _(%q{Destroy}) }</a>}
    else
      %Q{<a data-confirm="#{ _('Do you really want to delete %{record}?') % {:record => @profile.disp_name} }" data-method="post" href="#{ "/#{params[:lang]}" if params[:lang] }/profiles/destroy/#{ @profile.id }" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /> #{ _(%q{Destroy}) }</a>}
    end
    links << if @pres_mode == :list_zoom
      %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('profiles_element', '#{ "/#{params[:lang]}" if params[:lang] }/profiles/index', {asynchronous:true, evalScripts:true});location.href='#profiles_element'; return false;" rel="nofollow" title="#{ _(%q{Index of all profiles.}) }"><img src="/images/page_icons/award_star_gold_3.png" alt="#{ _(%q{Profiles}) }" title="#{ _(%q{Profiles}) }"/> #{ _(%q{Profiles}) }</a>}
    else
      %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/profiles/index" rel="nofollow" title="#{ _(%q{Index of all profiles.}) }"><img src="/images/page_icons/award_star_gold_3.png" alt="#{ _(%q{Profiles}) }" title="#{ _(%q{Profiles}) }"/> #{ _(%q{Profiles}) }</a>}
    end
    prev = Profile.first(:select => '`profiles`.id', :conditions => ["`profiles`.id < ?", @profile.id], :order => '`profiles`.id DESC')
    nex = Profile.first(:select => '`profiles`.id', :conditions => ["`profiles`.id > ?", @profile.id], :order => '`profiles`.id')
    if request.xhr?
      links << link_to_remote(image_tag('std/go_left.png', :title => _('Previous')), :update => 'profiles_element', :url => {:action => :edit, :id => prev.id}) if prev
      links << link_to_remote(image_tag('std/go_right.png', :title => _('Next')), :update => 'profiles_element', :url => {:action => :edit, :id => nex.id}) if nex
    else
      if prev
        links << if @pres_mode == :list_zoom
          %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('profiles_element', '#{ "/#{params[:lang]}" if params[:lang] }/profiles/edit/#{ prev.id }', {asynchronous:true, evalScripts:true});location.href='#profiles_element'; return false;" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/std/go_left.png" alt="#{ _(%q{Previous}) }" title="#{ _(%q{Previous}) }"/></a>}
        else
          %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/profiles/edit/#{ prev.id }" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/std/go_left.png" alt="#{ _(%q{Previous}) }" title="#{ _(%q{Previous}) }"/></a>}
        end
      end
      if nex
        links << if @pres_mode == :list_zoom
          %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('profiles_element', '#{ "/#{params[:lang]}" if params[:lang] }/profiles/edit/#{ nex.id }', {asynchronous:true, evalScripts:true});location.href='#profiles_element'; return false;" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/std/go_right.png" alt="#{ _(%q{Next}) }" title="#{ _(%q{Next}) }"/></a>}
        else
          %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/profiles/edit/#{ nex.id }" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/std/go_right.png" alt="#{ _(%q{Next}) }" title="#{ _(%q{Next}) }"/></a>}
        end
      end
    end
    return content_tag(:span, links.compact.join(' | ').html_safe, :class => 'std_links')
  end

end
