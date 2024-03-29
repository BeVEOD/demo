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
## It should be placed at 'app/helpers/file_imports_helper.rb'
## All manual modifications will be destroyed on next generation
################################################


module FileImportsHelper


  # Author:: Sylvain Abélard
  # Version:: 17
  # Last Update:: 2013-03-19 15:06:38 UTC
  # Status:: Validation Pending


  def bottom_links_for_show(opts={})

    links = []
    if request.xhr?
      links << link_to_remote(image_tag('std/edit.png', :title => _("Edit")), :update => 'file_imports_element', :url => {:action => :edit, :id => @file_import, :version => params[:version]})
    else
      links << if @pres_mode == :list_zoom
        %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/edit/#{ @file_import.id }', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/page_icons/page_white_paintbrush.png" alt="#{ _(%q{Edit}) }" title="#{ _(%q{Edit}) }" /> #{ _(%q{Edit}) }</a>}
      else
        %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/edit/#{ @file_import.id }" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/page_icons/page_white_paintbrush.png" alt="#{ _(%q{Edit}) }" title="#{ _(%q{Edit}) }" /> #{ _(%q{Edit}) }</a>}
      end
    end
    links << if @pres_mode == :list_zoom
      %Q{<a href="#" data-confirm="#{ _('Do you really want to delete %{record}?') % {:record => @file_import.disp_name} }" data-method="post" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/destroy/#{ @file_import.id }', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /> #{ _(%q{Destroy}) }</a>}
    else
      %Q{<a data-confirm="#{ _('Do you really want to delete %{record}?') % {:record => @file_import.disp_name} }" data-method="post" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/destroy/#{ @file_import.id }" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /> #{ _(%q{Destroy}) }</a>}
    end
    links << if @pres_mode == :list_zoom
      %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/index', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{Index of all file_imports.}) }"><img src="/images/page_icons/server_compressed.png" alt="#{ _(%q{File Imports}) }" title="#{ _(%q{File Imports}) }"/> #{ _(%q{File Imports}) }</a>}
    else
      %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/index" rel="nofollow" title="#{ _(%q{Index of all file_imports.}) }"><img src="/images/page_icons/server_compressed.png" alt="#{ _(%q{File Imports}) }" title="#{ _(%q{File Imports}) }"/> #{ _(%q{File Imports}) }</a>}
    end
    unless opts[:no_sibling]
      prev = FileImport.first(:select => '`file_imports`.id', :conditions => ["`file_imports`.id < ?", @file_import.id], :order => '`file_imports`.id DESC')
      nex = FileImport.first(:select => '`file_imports`.id', :conditions => ["`file_imports`.id > ?", @file_import.id], :order => '`file_imports`.id')
      if request.xhr?
        links << link_to_remote(image_tag('std/go_left.png', :title => _("Previous")), :update => 'file_imports_element', :url => {:action => :show, :id => prev.id}) if prev
        links << link_to_remote(image_tag('std/go_right.png', :title => _("Next")), :update => 'file_imports_element', :url => {:action => :show, :id => nex.id}) if nex
      else
        if prev
          links << if @pres_mode == :list_zoom
            %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/show/#{ prev.id }', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/go_left.png" alt="#{ _(%q{Previous}) }" title="#{ _(%q{Previous}) }"/></a>}
          else
            %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/show/#{ prev.id }" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/go_left.png" alt="#{ _(%q{Previous}) }" title="#{ _(%q{Previous}) }"/></a>}
          end
        end
        if nex
          links << if @pres_mode == :list_zoom
            %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/show/#{ nex.id }', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/go_right.png" alt="#{ _(%q{Next}) }" title="#{ _(%q{Next}) }"/></a>}
          else
            %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/show/#{ nex.id }" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/go_right.png" alt="#{ _(%q{Next}) }" title="#{ _(%q{Next}) }"/></a>}
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
      links << link_to_remote(image_tag('std/show.png', :title => _('Show')), :update => 'file_imports_element', :url => {:action => :show, :id => @file_import, :version => params[:version]})
    else
      links << if @pres_mode == :list_zoom
        %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/show/#{ @file_import.id }', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/show.png" alt="#{ _(%q{Show}) }" title="#{ _(%q{Show}) }" /> #{ _(%q{Show}) }</a>}
      else
        %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/show/#{ @file_import.id }" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/show.png" alt="#{ _(%q{Show}) }" title="#{ _(%q{Show}) }" /> #{ _(%q{Show}) }</a>}
      end
    end
    links << if @pres_mode == :list_zoom
      %Q{<a href="#" data-confirm="#{ _('Do you really want to delete %{record}?') % {:record => @file_import.disp_name} }" data-method="post" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/destroy/#{ @file_import.id }', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /> #{ _(%q{Destroy}) }</a>}
    else
      %Q{<a data-confirm="#{ _('Do you really want to delete %{record}?') % {:record => @file_import.disp_name} }" data-method="post" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/destroy/#{ @file_import.id }" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /> #{ _(%q{Destroy}) }</a>}
    end
    links << if @pres_mode == :list_zoom
      %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/index', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{Index of all file_imports.}) }"><img src="/images/page_icons/server_compressed.png" alt="#{ _(%q{File Imports}) }" title="#{ _(%q{File Imports}) }"/> #{ _(%q{File Imports}) }</a>}
    else
      %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/index" rel="nofollow" title="#{ _(%q{Index of all file_imports.}) }"><img src="/images/page_icons/server_compressed.png" alt="#{ _(%q{File Imports}) }" title="#{ _(%q{File Imports}) }"/> #{ _(%q{File Imports}) }</a>}
    end
    prev = FileImport.first(:select => '`file_imports`.id', :conditions => ["`file_imports`.id < ?", @file_import.id], :order => '`file_imports`.id DESC')
    nex = FileImport.first(:select => '`file_imports`.id', :conditions => ["`file_imports`.id > ?", @file_import.id], :order => '`file_imports`.id')
    if request.xhr?
      links << link_to_remote(image_tag('std/go_left.png', :title => _('Previous')), :update => 'file_imports_element', :url => {:action => :edit, :id => prev.id}) if prev
      links << link_to_remote(image_tag('std/go_right.png', :title => _('Next')), :update => 'file_imports_element', :url => {:action => :edit, :id => nex.id}) if nex
    else
      if prev
        links << if @pres_mode == :list_zoom
          %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/edit/#{ prev.id }', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/std/go_left.png" alt="#{ _(%q{Previous}) }" title="#{ _(%q{Previous}) }"/></a>}
        else
          %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/edit/#{ prev.id }" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/std/go_left.png" alt="#{ _(%q{Previous}) }" title="#{ _(%q{Previous}) }"/></a>}
        end
      end
      if nex
        links << if @pres_mode == :list_zoom
          %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/edit/#{ nex.id }', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/std/go_right.png" alt="#{ _(%q{Next}) }" title="#{ _(%q{Next}) }"/></a>}
        else
          %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/edit/#{ nex.id }" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/std/go_right.png" alt="#{ _(%q{Next}) }" title="#{ _(%q{Next}) }"/></a>}
        end
      end
    end
    return content_tag(:span, links.compact.join(' | ').html_safe, :class => 'std_links')
  end


  # Displays details about series
  #
  # Author:: Sylvain Abélard
  # Version:: 1
  # Last Update:: 2009-10-05 13:31:56 UTC
  # Status:: In Progress


  def series_details(s, txt=nil)
    return 'empty' if s.blank?
    info = "#{s.calculation}"
    info << " of #{s.field.name}" if s.field
      info << " by #{s.key_field.name}" if s.key_field
        details = txt || info
        content_tag(:span,
        content_tag(:span, '&nbsp;&nbsp;&nbsp;', :style => "background-color: #{s.html_color}; border: 1px inset gray;") +
        " #{s.disp_name} [#{details}]",
        :title => info,
        :class => "report_#{s.serie_type.downcase}")
      end


      # Generally used for list actions.
      #
      # Author:: Sylvain Abélard
      # Version:: 2
      # Last Update:: 2013-03-29 11:12:53 UTC
      # Status:: In Progress


      def links_for_list_element(row, opts={})
        return "" if @no_row_links
        html = []
        html << if @pres_mode == :list_zoom
          %Q{<a href="#" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/preview/#{ row.id }', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;"><img src="/images/page_icons/application_view_detail.png" alt="#{ _(%q{Preview}) }" title="#{ _(%q{Preview}) }" /></a>}
        else
          %Q{<a href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/preview/#{ row.id }"><img src="/images/page_icons/application_view_detail.png" alt="#{ _(%q{Preview}) }" title="#{ _(%q{Preview}) }" /></a>}
        end
        html << if @pres_mode == :list_zoom
          %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/show/#{ row.id }', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/show.png" alt="#{ _(%q{Show}) }" title="#{ _(%q{Show}) }" /></a>}
        else
          %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/show/#{ row.id }" rel="nofollow" title="#{ _(%q{Display the record.}) }"><img src="/images/std/show.png" alt="#{ _(%q{Show}) }" title="#{ _(%q{Show}) }" /></a>}
        end
        html << if @pres_mode == :list_zoom
          %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/edit/#{ row.id }', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/page_icons/page_white_paintbrush.png" alt="#{ _(%q{Edit}) }" title="#{ _(%q{Edit}) }" /></a>}
        else
          %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/edit/#{ row.id }" rel="nofollow" title="#{ _(%q{Load the data to fill the edit form.}) }"><img src="/images/page_icons/page_white_paintbrush.png" alt="#{ _(%q{Edit}) }" title="#{ _(%q{Edit}) }" /></a>}
        end
        html << nil
        html << link_to(image_tag('page_icons/table_gear.png', :title => _('Load')),
        {:controller => :file_imports, :action => :load, :id => row.id},
        :confirm => _("Load file?"), :method => :post)
        html << if @pres_mode == :list_zoom
          %Q{<a href="#" data-confirm="#{ _('Do you really want to delete %{record}?') %
          {:record => @file_import.disp_name} }" data-method="post" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/destroy/#{ @file_import.id }', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /></a>}
        else
          %Q{<a data-confirm="#{ _('Do you really want to delete %{record}?') %
          {:record => @file_import.disp_name} }" data-method="post" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/destroy/#{ @file_import.id }" title="#{ _(%q{Deletes an object or list of objects from the database.}) }"><img src="/images/page_icons/cancel.png" alt="#{ _(%q{Destroy}) }" title="#{ _(%q{Destroy}) }" /></a>}
        end
        return html.compact.join(' | ').html_safe
      end


      #--
      # DEPRECATED: this helper would be removed
      #++
      # Author:: Sylvain Abélard
      # Version:: 3
      # Last Update:: 2013-03-29 12:09:36 UTC
      # Status:: Validated


      def list_tabs
        return "" if @no_row_links
        html = []
        html << if @pres_mode == :list_zoom
          %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/source_files', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{This gives the list of all records}) }"><img src="/images/page_icons/folder_page.png" alt="#{ _(%q{Source Files}) }" title="#{ _(%q{Source Files}) }" /> #{ _(%q{Source Files}) }</a>}
        else
          %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/source_files" rel="nofollow" title="#{ _(%q{This gives the list of all records}) }"><img src="/images/page_icons/folder_page.png" alt="#{ _(%q{Source Files}) }" title="#{ _(%q{Source Files}) }" /> #{ _(%q{Source Files}) }</a>}
        end
        html << if @pres_mode == :list_zoom
          %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/running', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{This gives the list of all records}) }"><img src="/images/page_icons/page_refresh.png" alt="#{ _(%q{Running}) }" title="#{ _(%q{Running}) }" /> #{ _(%q{Running}) }</a>}
        else
          %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/running" rel="nofollow" title="#{ _(%q{This gives the list of all records}) }"><img src="/images/page_icons/page_refresh.png" alt="#{ _(%q{Running}) }" title="#{ _(%q{Running}) }" /> #{ _(%q{Running}) }</a>}
        end
        html << if @pres_mode == :list_zoom
          %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/complete', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{This gives the list of all records}) }"><img src="/images/page_icons/tick.png" alt="#{ _(%q{Complete}) }" title="#{ _(%q{Complete}) }" /> #{ _(%q{Complete}) }</a>}
        else
          %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/complete" rel="nofollow" title="#{ _(%q{This gives the list of all records}) }"><img src="/images/page_icons/tick.png" alt="#{ _(%q{Complete}) }" title="#{ _(%q{Complete}) }" /> #{ _(%q{Complete}) }</a>}
        end
        html << if @pres_mode == :list_zoom
          %Q{<a href="#" data-method="get" onclick="new Ajax.Updater('file_imports_element', '#{ "/#{params[:lang]}" if params[:lang] }/file_imports/list', {asynchronous:true, evalScripts:true});location.href='#file_imports_element'; return false;" rel="nofollow" title="#{ _(%q{This gives the list of all records}) }"><img src="/images/page_icons/application_view_list.png" alt="#{ _(%q{List}) }" title="#{ _(%q{List}) }" /> #{ _(%q{All}) }</a>}
        else
          %Q{<a data-method="get" href="#{ "/#{params[:lang]}" if params[:lang] }/file_imports/list" rel="nofollow" title="#{ _(%q{This gives the list of all records}) }"><img src="/images/page_icons/application_view_list.png" alt="#{ _(%q{List}) }" title="#{ _(%q{List}) }" /> #{ _(%q{All}) }</a>}
        end
        return "[ #{html.compact.join(' | ')} ]".html_safe
      end

    end
