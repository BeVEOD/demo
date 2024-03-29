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
## This has been generated by Faveod Generator on Thu Oct 31 16:40:26 +0100 2013
## It should be placed at 'app/helpers/customers_helper.rb'
## All manual modifications will be destroyed on next generation
################################################


module CustomersHelper


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
      :url => {:controller => :customers, :action => :show, :id => row.id},
      :update => "customers_element")
      html << link_to_remote(image_tag('std/edit.png', :title => _('Edit')),
      :url => {:controller => :customers, :action => :edit, :id => row.id},
      :update => "customers_element")
    else
      html << if @pres_mode == :list_zoom
        %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('customers_element', '#{ "/#{params[:lang]}" if params[:lang] }/customers/show/#{ row.id }', {asynchronous:true, evalScripts:true});location.href='#customers_element'; return false;" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/show.png" alt="#{ _(%q{Show}) }" title="#{ _(%q{Show}) }" /></a>}
      else
        %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/customers/show/#{ row.id }" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/show.png" alt="#{ _(%q{Show}) }" title="#{ _(%q{Show}) }" /></a>}
      end
      html << if @pres_mode == :list_zoom
        %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('customers_element', '#{ "/#{params[:lang]}" if params[:lang] }/customers/edit/#{ row.id }', {asynchronous:true, evalScripts:true});location.href='#customers_element'; return false;" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/page_icons/page_white_paintbrush.png" alt="#{ _(%q{Edit}) }" title="#{ _(%q{Edit}) }" /></a>}
      else
        %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/customers/edit/#{ row.id }" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/page_icons/page_white_paintbrush.png" alt="#{ _(%q{Edit}) }" title="#{ _(%q{Edit}) }" /></a>}
      end
      html << nil
    end
    html << if @pres_mode == :list_zoom
      %Q{<a href="#" data-confirm="#{ _('Do you really want to delete %{record}?') %
      {:record => @customer.disp_name} }" data-method="post" onclick="new Ajax.Updater('customers_element', '#{ "/#{params[:lang]}" if params[:lang] }/customers/destroy/#{ @customer.id }', {asynchronous:true, evalScripts:true});location.href='#customers_element'; return false;" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /></a>}
    else
      %Q{<a data-confirm="#{ _('Do you really want to delete %{record}?') %
      {:record => @customer.disp_name} }" data-method="post" href="#{ "/#{params[:lang]}" if params[:lang] }/customers/destroy/#{ @customer.id }" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /></a>}
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
      links << link_to_remote(image_tag('std/edit.png', :title => _("Edit")), :update => 'customers_element', :url => {:action => :edit, :id => @customer, :version => params[:version]})
    else
      links << if @pres_mode == :list_zoom
        %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('customers_element', '#{ "/#{params[:lang]}" if params[:lang] }/customers/edit/#{ @customer.id }', {asynchronous:true, evalScripts:true});location.href='#customers_element'; return false;" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/page_icons/page_white_paintbrush.png" alt="#{ _(%q{Edit}) }" title="#{ _(%q{Edit}) }" /> #{ _(%q{Edit}) }</a>}
      else
        %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/customers/edit/#{ @customer.id }" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/page_icons/page_white_paintbrush.png" alt="#{ _(%q{Edit}) }" title="#{ _(%q{Edit}) }" /> #{ _(%q{Edit}) }</a>}
      end
    end
    links << if @pres_mode == :list_zoom
      %Q{<a href="#" data-confirm="#{ _('Do you really want to delete %{record}?') % {:record => @customer.disp_name} }" data-method="post" onclick="new Ajax.Updater('customers_element', '#{ "/#{params[:lang]}" if params[:lang] }/customers/destroy/#{ @customer.id }', {asynchronous:true, evalScripts:true});location.href='#customers_element'; return false;" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /> #{ _(%q{Destroy}) }</a>}
    else
      %Q{<a data-confirm="#{ _('Do you really want to delete %{record}?') % {:record => @customer.disp_name} }" data-method="post" href="#{ "/#{params[:lang]}" if params[:lang] }/customers/destroy/#{ @customer.id }" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /> #{ _(%q{Destroy}) }</a>}
    end
    links << if @pres_mode == :list_zoom
      %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('customers_element', '#{ "/#{params[:lang]}" if params[:lang] }/customers/index', {asynchronous:true, evalScripts:true});location.href='#customers_element'; return false;" rel="nofollow" title="#{ _(%q{Index of all customers.}) }"><img src="/images/default/s.gif" alt="#{ _(%q{Customers}) }" title="#{ _(%q{Customers}) }" width="16" /> #{ _(%q{Customers}) }</a>}
    else
      %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/customers/index" rel="nofollow" title="#{ _(%q{Index of all customers.}) }"><img src="/images/default/s.gif" alt="#{ _(%q{Customers}) }" title="#{ _(%q{Customers}) }" width="16" /> #{ _(%q{Customers}) }</a>}
    end
    unless opts[:no_sibling]
      prev = Customer.first(:select => '`customers`.id', :conditions => ["`customers`.id < ?", @customer.id], :order => '`customers`.id DESC')
      nex = Customer.first(:select => '`customers`.id', :conditions => ["`customers`.id > ?", @customer.id], :order => '`customers`.id')
      if request.xhr?
        links << link_to_remote(image_tag('std/go_left.png', :title => _("Previous")), :update => 'customers_element', :url => {:action => :show, :id => prev.id}) if prev
        links << link_to_remote(image_tag('std/go_right.png', :title => _("Next")), :update => 'customers_element', :url => {:action => :show, :id => nex.id}) if nex
      else
        if prev
          links << if @pres_mode == :list_zoom
            %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('customers_element', '#{ "/#{params[:lang]}" if params[:lang] }/customers/show/#{ prev.id }', {asynchronous:true, evalScripts:true});location.href='#customers_element'; return false;" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/go_left.png" alt="#{ _(%q{Previous}) }" title="#{ _(%q{Previous}) }"/></a>}
          else
            %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/customers/show/#{ prev.id }" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/go_left.png" alt="#{ _(%q{Previous}) }" title="#{ _(%q{Previous}) }"/></a>}
          end
        end
        if nex
          links << if @pres_mode == :list_zoom
            %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('customers_element', '#{ "/#{params[:lang]}" if params[:lang] }/customers/show/#{ nex.id }', {asynchronous:true, evalScripts:true});location.href='#customers_element'; return false;" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/go_right.png" alt="#{ _(%q{Next}) }" title="#{ _(%q{Next}) }"/></a>}
          else
            %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/customers/show/#{ nex.id }" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/go_right.png" alt="#{ _(%q{Next}) }" title="#{ _(%q{Next}) }"/></a>}
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
      links << link_to_remote(image_tag('std/show.png', :title => _('Show')), :update => 'customers_element', :url => {:action => :show, :id => @customer, :version => params[:version]})
    else
      links << if @pres_mode == :list_zoom
        %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('customers_element', '#{ "/#{params[:lang]}" if params[:lang] }/customers/show/#{ @customer.id }', {asynchronous:true, evalScripts:true});location.href='#customers_element'; return false;" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/show.png" alt="#{ _(%q{Show}) }" title="#{ _(%q{Show}) }" /> #{ _(%q{Show}) }</a>}
      else
        %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/customers/show/#{ @customer.id }" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/show.png" alt="#{ _(%q{Show}) }" title="#{ _(%q{Show}) }" /> #{ _(%q{Show}) }</a>}
      end
    end
    links << if @pres_mode == :list_zoom
      %Q{<a href="#" data-confirm="#{ _('Do you really want to delete %{record}?') % {:record => @customer.disp_name} }" data-method="post" onclick="new Ajax.Updater('customers_element', '#{ "/#{params[:lang]}" if params[:lang] }/customers/destroy/#{ @customer.id }', {asynchronous:true, evalScripts:true});location.href='#customers_element'; return false;" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /> #{ _(%q{Destroy}) }</a>}
    else
      %Q{<a data-confirm="#{ _('Do you really want to delete %{record}?') % {:record => @customer.disp_name} }" data-method="post" href="#{ "/#{params[:lang]}" if params[:lang] }/customers/destroy/#{ @customer.id }" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /> #{ _(%q{Destroy}) }</a>}
    end
    links << if @pres_mode == :list_zoom
      %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('customers_element', '#{ "/#{params[:lang]}" if params[:lang] }/customers/index', {asynchronous:true, evalScripts:true});location.href='#customers_element'; return false;" rel="nofollow" title="#{ _(%q{Index of all customers.}) }"><img src="/images/default/s.gif" alt="#{ _(%q{Customers}) }" title="#{ _(%q{Customers}) }" width="16" /> #{ _(%q{Customers}) }</a>}
    else
      %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/customers/index" rel="nofollow" title="#{ _(%q{Index of all customers.}) }"><img src="/images/default/s.gif" alt="#{ _(%q{Customers}) }" title="#{ _(%q{Customers}) }" width="16" /> #{ _(%q{Customers}) }</a>}
    end
    prev = Customer.first(:select => '`customers`.id', :conditions => ["`customers`.id < ?", @customer.id], :order => '`customers`.id DESC')
    nex = Customer.first(:select => '`customers`.id', :conditions => ["`customers`.id > ?", @customer.id], :order => '`customers`.id')
    if request.xhr?
      links << link_to_remote(image_tag('std/go_left.png', :title => _('Previous')), :update => 'customers_element', :url => {:action => :edit, :id => prev.id}) if prev
      links << link_to_remote(image_tag('std/go_right.png', :title => _('Next')), :update => 'customers_element', :url => {:action => :edit, :id => nex.id}) if nex
    else
      if prev
        links << if @pres_mode == :list_zoom
          %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('customers_element', '#{ "/#{params[:lang]}" if params[:lang] }/customers/edit/#{ prev.id }', {asynchronous:true, evalScripts:true});location.href='#customers_element'; return false;" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/std/go_left.png" alt="#{ _(%q{Previous}) }" title="#{ _(%q{Previous}) }"/></a>}
        else
          %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/customers/edit/#{ prev.id }" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/std/go_left.png" alt="#{ _(%q{Previous}) }" title="#{ _(%q{Previous}) }"/></a>}
        end
      end
      if nex
        links << if @pres_mode == :list_zoom
          %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('customers_element', '#{ "/#{params[:lang]}" if params[:lang] }/customers/edit/#{ nex.id }', {asynchronous:true, evalScripts:true});location.href='#customers_element'; return false;" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/std/go_right.png" alt="#{ _(%q{Next}) }" title="#{ _(%q{Next}) }"/></a>}
        else
          %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/customers/edit/#{ nex.id }" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/std/go_right.png" alt="#{ _(%q{Next}) }" title="#{ _(%q{Next}) }"/></a>}
        end
      end
    end
    return content_tag(:span, links.compact.join(' | ').html_safe, :class => 'std_links')
  end

end
