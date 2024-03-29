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
## This has been generated by Faveod Generator on Wed Aug 28 16:13:34 +0200 2013
## It should be placed at 'app/controllers/uncatched_exceptions_controller.rb'
## All manual modifications will be destroyed on next generation
################################################


class UncatchedExceptionsController < ApplicationController
  layout 'application_jquery_horizontal'

  before_filter(:faveod_cookies_loading)

  before_filter(:only => :list) do
    request.request_method_symbol == :get
  end

  # Index of all <%= model.sid %>.
  #
  # Author:: Yann Azoury
  # Version:: 10
  # Last Update:: 2012-05-20 16:26:24 UTC
  # Status:: Validation Pending


  def index

    list
    unless(%w(json xml).include?(params[:format]))
      render(:action => :list)
    end
  end


  # This gives the list of all records
  #
  # Author:: Yann Azoury
  # Version:: 24
  # Last Update:: 2013-01-29 17:02:44 UTC
  # Status:: Validation Pending


  def list

    @restricted_fields = []
    pagin_opts = {:include => []}
    pagin_opts[:page]	  = params[:page].to_i > 0 ? params[:page].to_i : 1
    pagin_opts[:per_page]	  = (params[:per_page] || cookies[:uncatched_exceptions_per_page] || 50).to_i
    pagin_opts[:order]	  = @default_order if @default_order
    pagin_opts[:order]	||= 'uncatched_exceptions.' +params[:sort_by] if !params[:sort_by].blank?
    pagin_opts[:conditions] ||= @default_filter if @default_filter
    pagin_opts[:conditions] ||= params[:conditions] if params[:conditions].is_a?(Hash)
    pagin_opts[:joins]	||= @joins_fields || []

    @uncatched_exceptions = UncatchedException.paginate(pagin_opts)
    render(:xml => @uncatched_exceptions.to_xml(:dasherize => false, :only => [:id,:exception_class,:controller_name,:action_name,:message,:backtrace,:environment,:request,:created_at])) and return if params[:format] == 'xml'
    render(:json => @uncatched_exceptions) and return if params[:format] == 'json'
    render(:pdf => @uncatched_exceptions, :action => :list) and return if params[:format] == 'pdf'
    if !params[:group_by].blank? && ["exception_class", "controller_name", "action_name", "created_at"].include?(params[:group_by])
      @uncatched_exceptions_groups = @uncatched_exceptions.inject({}) { |acc,elt|
        crit = nil
        if [].include?(params[:group_by])
          crit = elt.send(params[:group_by]) ? elt.send(params[:group_by]).disp_name : nil
        else
          crit = elt.attributes[params[:group_by]]
        end
        acc[crit] ||= []
        acc[crit] << elt
        acc
      }
    end
  end


  # Display the record.
  #
  # Author:: Yann Azoury
  # Version:: 14
  # Last Update:: 2012-03-26 04:12:53 UTC
  # Status:: Validation Pending


  def show

    @uncatched_exception_attributes = params[:uncatched_exception] ? params[:uncatched_exception][params[:id]].clone : {}
    @uncatched_exception_attributes.merge!(:id => params[:id]) if @uncatched_exception_attributes

    @uncatched_exception = UncatchedException.load_from_params(@uncatched_exception_attributes)
    if @uncatched_exception.nil?
      flash[:warning] ||= []
      flash[:warning] << _("Warning: %{obj} with ID %{id} does not exist!") % {:obj => 'uncatched_exception', :id => params[:id]}
      redirect_to(:action => :index)
      return
    end

    respond_to do |format|
      format.html {
      render :layout => !request.xhr? }
      format.pdf {
      render :layout => false }
      format.xml {
      render :xml => @uncatched_exception.to_xml }
      format.json {
      render :json => @uncatched_exception.to_json }
    end
  end


  # Deletes an object or list of objects from the database.
  #
  # Author:: Yann Azoury
  # Version:: 9
  # Last Update:: 2011-03-08 15:34:31 UTC
  # Status:: Validation Pending


  def destroy

    if params[:id].is_a?(Array)
      @success = UncatchedException.destroy(params[:id])
    else
      @uncatched_exception = UncatchedException.find_by_id(params[:id])
      @uncatched_exception.destroy unless @uncatched_exception.nil?
      @success = @uncatched_exception && @uncatched_exception.destroyed?
    end
    if @success
      flash[:notice] = _("%{model} %{name} successfully deleted.") % {:model => _("Uncatched Exception"), :name => @uncatched_exception.disp_name}
    else
      flash[:warning] = _("%{model} %{name} could not be deleted.") % {:model => _("Uncatched Exception"), :name => params[:name]}
    end
    if params[:format] != "json"
      if request.xhr?
        render :action => 'ajax_update', :layout => false
      else
        if params[:go_to].blank?
          redirect_to :action => :index
        else
          redirect_to(params[:go_to])
        end
      end
    else
      resp = {}
      if @success
        resp[:success] = true
      else
        resp[:success] = false
        resp[:error] = flash[:warning]
      end
      render :json => resp.to_json, :layout => false
    end
  end


  # Search and filter data.
  #
  # Author:: Sylvain Abélard
  # Version:: 44
  # Last Update:: 2010-06-15 18:38:22 UTC
  # Status:: Requires Tests


  def search

    @uncatched_exception = UncatchedException.load_from_params(params[:uncatched_exception]["0"]) if params[:uncatched_exception]
    @uncatched_exception ||= UncatchedException.new
    page	   = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page   = params[:per_page]
    per_page ||= UncatchedException.count if params[:format] && %w(xml xls csv).include?(params[:format])
    per_page   = 50 if !per_page || per_page == 0

    # GET RESULTS FROM SMART_QUERY OR PARAMS

    if params[:uncatched_exception]
      my_p = params[:uncatched_exception]["0"].reject{|k, v|
        params["comp_#{k}"].blank? || (v.blank? && !params["comp_#{k}"].include?('NULL'))
      } if params[:uncatched_exception]["0"]
      @uncatched_exceptions = UncatchedException.search(my_p, params.reject{|k,v| !k[/comp_/]}, :page => page, :per_page => per_page)
    elsif params[:query]
      @uncatched_exceptions = UncatchedException.active_filter(ActiveSupport::JSON.decode(params[:query])).paginate(:page => page, :per_page => per_page)
    elsif params[:fts_query]
      l = params[:limit] ? params[:limit] : :all
      @uncatched_exceptions = UncatchedException.find_with_ferret(params[:fts_query], :limit => l)
    elsif (params[:id] || params[:smart_query])
      if params[:id]
        @smart_query = SmartQuery.find_by_id(params[:id])
      else
        attr = params[:smart_query].first[1] if params[:smart_query].first
        attr[:criteria] = SmartQuery.clean_criteria(attr[:criteria])
        @smart_query = SmartQuery.new(attr)
      end
      @uncatched_exceptions = UncatchedException.search(@smart_query, :page => page, :per_page => per_page)
    else
      opts = {:include => []}
      opts[:page]		  = page
      opts[:per_page]	  = per_page
      opts[:order]		  = @default_order
      opts[:order]		||= 'uncatched_exceptions.' +params[:sort_by] if !params[:sort_by].blank?
      opts[:conditions]	||= @default_filter
      opts[:joins] 		||= @joins_fields  || []
      @uncatched_exceptions = UncatchedException.paginate(opts)
    end

    # RENDER SOMETHING

    if !@uncatched_exceptions.blank? && params[:format] # GET
      if params[:format] == 'xml'
        send_data(@uncatched_exceptions.to_xml,
        :filename => ('uncatched_exceptions.xml'),
        :disposition => 'attachment',
        :type => 'text/xml;charset=utf-8')
        return
      elsif params[:format] == 'xls'
        cols = []
        UncatchedException::FIELDS.each{|k,v|
        cols << k if [:string, :text, :integer, :float, :decimal, :date, :time, :datetime, :timestamp, :ho_assoc, :bt_assoc].include? v}
        book = Spreadsheet::Workbook.new
        sheet = book.create_worksheet(:name => "uncatched_exceptions")
        sheet.row(0).concat(cols)
        @uncatched_exceptions.each_with_index do |row,i|
          sheet.row(i+1).replace(cols.map{|c|
            if [:ho_assoc, :bt_assoc].include?(UncatchedException::FIELDS[c])
              v = row.send(c)
              v ? v.disp_name : ''
            else
              row.send(c)
            end
          })
        end
        fname = "uncatched_exceptions.xls"
        tmp = Tempfile.new(fname)
        book.write(tmp.path)
        tmp.close
        send_file(tmp.path, :filename => fname)
        return
      elsif params[:format] == 'csv'
        cols = UncatchedException::FIELDS.inject([]) {|a,v|
        a << v[0] if [:ho_assoc, :bt_assoc, :string, :text, :integer, :float, :decimal, :date, :time, :datetime, :timestamp].include?(v[1]) ; a}
        @csv_string = FasterCSV.generate({:encoding => 'UTF-8', :col_sep => (SystemSetting['csv_export_separator'] || ';') }) do |csv|
          csv << cols
          for row in @uncatched_exceptions
            csv << cols.map{|c|
              if [:ho_assoc, :bt_assoc].include?(UncatchedException::FIELDS[c])
                v = row.send(c) ; v ? v.disp_name : nil
              else
                row.send(c)
              end
            }
          end
        end
        @export_encoding ||= SystemSetting['csv_export_encoding'] || 'UTF-16LE'
        conv = Iconv.new(@export_encoding, 'UTF-8')
        send_data(conv.iconv(@csv_string), :filename => "uncatched_exceptions.csv", :disposition => 'attachment', :type => "text/csv;charset=#{@export_encoding.downcase}")
        return
      end
    end
    if request.xhr? || request.post?
      render :partial => 'result_list' and return
    end
  end


  # Allows download of all or current record in many formats.
  #
  # Author:: Yann Azoury
  # Version:: 46
  # Last Update:: 2013-02-11 07:45:35 UTC
  # Status:: Validation Pending


  def download

    @restricted_fields = []
    @no_menubar	= true
    @no_links	= true
    @no_filterbar	= true
    @no_row_links	= true
    pagin_opts		  = {:include => []}
    pagin_opts[:order]	  = @default_order if @default_order
    pagin_opts[:order]	||= "uncatched_exceptions.#{params[:sort_by]}" if !params[:sort_by].blank?
    pagin_opts[:conditions] ||= @default_filter
    pagin_opts[:joins]	||= @joins_fields || []

    # pagin_opts[:select]	||= "`uncatched_exceptions`.`exception_class`,`uncatched_exceptions`.`controller_name`,`uncatched_exceptions`.`action_name`,`uncatched_exceptions`.`message`,`uncatched_exceptions`.`backtrace`,`uncatched_exceptions`.`environment`,`uncatched_exceptions`.`request`,`uncatched_exceptions`.`created_at`" unless params[:format] == 'html'

    if params[:id] && params[:id].to_i > 0
      @uncatched_exception = UncatchedException.find_by_id(params[:id], pagin_opts)
      if !@uncatched_exception
        flash[:warning] = _("Error: %{obj} not found!") % {:obj => _(%q[UncatchedException])}
        begin
          redirect_to :back
        rescue
          redirect_to :action => :list
        end
        return
      end
      f_name = @uncatched_exception.disp_name
      respond_to do |format|
        format.html {
          @no_menubar = true
          @no_links = true
          data = render_to_string(:template => '/uncatched_exceptions/show.html.erb', :layout => 'minimal').gsub(/\ssrc=\"\//, %Q[ src="#{request.protocol}#{request.host_with_port}/])
        send_data(data, :filename => "#{f_name}.html", :disposition => 'attachment', :type => 'text/html;charset=utf-8') }
        format.doc {
          @no_menubar = true
          @no_links = true
          data = render_to_string(:template => '/uncatched_exceptions/show.html.erb', :layout => 'minimal').gsub(/\ssrc=\"\//, %Q[ src="#{request.protocol}#{request.host_with_port}/])
        send_data(data, :filename => "#{f_name}.doc", :disposition => 'attachment', :type => 'application/msword;charset=utf-8') }
        format.pdf {
          @pdf = true
          @debug_pdf = params[:debug_pdf]
          params[:format] = 'html'
          html = render_to_string(:template => '/uncatched_exceptions/show.html.erb', :format => :html, :id => @uncatched_exception.id, :layout => 'pdf')
          html.gsub!(/\/images\//, Rails.root.join('public', 'images/')) if !params[:debug_pdf]
          render(:text => html,  :layout => 'pdf') and return if params[:debug_pdf]
          kit = PDFKit.new(html, :encoding => 'UTF-8')
          kit.stylesheets << Rails.root.join('public', 'stylesheets', 'pdf.css')
          pdf = kit.to_pdf
          send_data(pdf, :filename => "#{@uncatched_exception.disp_name}.pdf") unless params[:debug_pdf] || pdf.blank?

          # send_data(render_to_string(:format => :html, :layout => false, :action => :show, :id => @uncatched_exception.id), :filename => "#{f_name}.pdf", :disposition => 'attachment', :type => 'application/pdf;charset=utf-8')

          return
        }
        format.xml {
        send_data(@uncatched_exception.to_xml, :filename => "#{f_name}.xml", :disposition => 'attachment', :type => 'text/xml;charset=utf-8')}
        format.json {
        send_data(@uncatched_exception.to_json, :filename => "#{f_name}.json", :disposition => 'attachment', :type => 'text/json;charset=utf-8')}
        format.xls {
          book = Spreadsheet::Workbook.new
          sheet = book.create_worksheet(:name => "uncatched_exceptions")
          sheet.row(0).concat(["Exception Class", "Controller Name", "Action Name", "Message", "Backtrace", "Environment", "Request", "Created At"])
          sheet.row(1).replace([@uncatched_exception.exception_class, @uncatched_exception.controller_name, @uncatched_exception.action_name, @uncatched_exception.message, @uncatched_exception.backtrace, @uncatched_exception.environment, @uncatched_exception.request, @uncatched_exception.created_at])
          fname = "uncatched_exceptions.xls"
          tmp = Tempfile.new(fname)
          book.write(tmp.path)
          tmp.close
          send_file(tmp.path, :filename => fname)
        }
        format.csv { row = @uncatched_exception
          @csv_string = FasterCSV.generate({:encoding => 'UTF-8', :col_sep => (SystemSetting['csv_export_separator'] || ';')}) do |csv|
            cols = []
            UncatchedException::FIELDS.each{|k,v| cols << k if [:string, :text, :integer, :float, :date, :time, :datetime, :timestamp, :ho_assoc, :bt_assoc].include? v}
            cols.reject!{|c| [].include?(c) }
            csv << cols.map{|c|
              if [:ho_assoc, :bt_assoc].include?(UncatchedException::FIELDS[c])
                v = row.send(c) ; v ? v.disp_name : nil
              else
                row.send(c)
              end
            }
          end
          @export_encoding ||= SystemSetting['csv_export_encoding'] || 'UTF-16LE'
          conv = Iconv.new(@export_encoding, 'UTF-8')
          send_data(conv.iconv(@csv_string), :filename => "#{f_name}.csv", :disposition => 'attachment', :type => "text/csv;charset=#{@export_encoding.downcase}")
          return
        }
      end
    else
      pagin_opts[:page] = 1
      pagin_opts[:per_page] = UncatchedException.count+1
      @uncatched_exceptions = UncatchedException.paginate(pagin_opts)
      respond_to do |format|
        format.html {
          @no_menubar = true
          @no_links = true
          data = render_to_string(:template => '/uncatched_exceptions/list.html.erb', :layout => 'minimal').gsub(/\ssrc=\"\//, %Q[ src="#{request.protocol}#{request.host_with_port}/])
        send_data(data, :filename => "uncatched_exceptions.html", :disposition => 'attachment', :type => 'text/html;charset=utf-8') }
        format.doc {
          @no_menubar = true
          @no_links = true
          data = render_to_string(:template => '/uncatched_exceptions/list.html.erb', :layout => 'minimal').gsub(/\ssrc=\"\//, %Q[ src="#{request.protocol}#{request.host_with_port}/])
        send_data(data, :filename => "uncatched_exceptions.doc", :disposition => 'attachment', :type => 'application/msword;charset=utf-8') }
        format.pdf {
          @pdf = true
          @debug_pdf = params[:debug_pdf]
          params[:format] = 'html'
          html = render_to_string(:template => '/uncatched_exceptions/list.html.erb', :layout => 'pdf')
          html.gsub!(/\/images\//, Rails.root.join('public', 'images/')) if !params[:debug_pdf]
          render(:text => html,  :layout => 'pdf') and return if params[:debug_pdf]
          kit = PDFKit.new(html, :encoding => 'UTF-8')
          kit.stylesheets << Rails.root.join('public', 'stylesheets', 'pdf.css')
          pdf = kit.to_pdf
          send_data(pdf, :filename => "uncatched_exceptions.pdf") unless params[:debug_pdf] || pdf.blank?

          #      send_data(render_to_string(:layout => false, :action => :list), :filename => "uncatched_exceptions.pdf", :disposition => 'attachment', :type => 'application/pdf;charset=utf-8')

        }
        format.xml {
        send_data(@uncatched_exceptions.to_xml, :filename => ('uncatched_exceptions.xml'), :disposition => 'attachment', :type => 'text/xml;charset=utf-8')}
        format.xls {
          book = Spreadsheet::Workbook.new
          sheet = book.create_worksheet(:name => "uncatched_exceptions")
          sheet.row(0).concat(["Exception Class", "Controller Name", "Action Name", "Message", "Backtrace", "Environment", "Request", "Created At"])
          @uncatched_exceptions.each_with_index do |row,i|
            sheet.row(i+1).replace([row.exception_class, row.controller_name, row.action_name, row.message, row.backtrace, row.environment, row.request, row.created_at])
          end
          fname = "uncatched_exceptions.xls"
          tmp = Tempfile.new(fname)
          book.write(tmp.path)
          tmp.close
          send_file(tmp.path, :filename => fname)
        }
        format.csv {
          @csv_string = FasterCSV.generate({:encoding => 'UTF-8', :col_sep => (SystemSetting['csv_export_separator'] || ';')}) do |csv|
            cols = []
            UncatchedException::FIELDS.each{|k,v| cols << k if [:string, :text, :integer, :float, :date, :time, :datetime, :timestamp, :ho_assoc, :bt_assoc].include? v}
            cols.reject!{|c| [].include?(c) }
            csv << cols.map{|c| _(c.titleize)}
            @uncatched_exceptions.map{|row|
              csv << cols.map {|c|
                if [:ho_assoc, :bt_assoc].include?(UncatchedException::FIELDS[c])
                  v = row.send(c) ; v ? v.disp_name : nil
                else
                  row.send(c)
                end
              }
            }
          end
          @export_encoding ||= SystemSetting['csv_export_encoding'] || 'UTF-16LE'
          conv = Iconv.new(@export_encoding, 'UTF-8')
          send_data(conv.iconv(@csv_string), :filename => "uncatched_exceptions.csv", :disposition => 'attachment', :type => "text/csv;charset=#{@export_encoding.downcase}")
        }
      end
    end
  end


  # Exports RSS, XML and ATOM feeds.
  #
  # Author:: Sylvain Abélard
  # Version:: 6
  # Last Update:: 2010-06-16 12:11:11 UTC
  # Status:: Validation Pending


  def feed

    @uncatched_exceptions = UncatchedException.all(:limit => 50)
    respond_to do |format|
      format.rss {render :template => 'uncatched_exceptions/rss', :layout => false}
      format.xml {render :template => 'uncatched_exceptions/rss', :layout => false}
      format.html {render :template => 'uncatched_exceptions/rss', :layout => false}
      format.atom {render :template => 'uncatched_exceptions/atom', :layout => false}
    end
  end


  # Gives help about current module.
  #
  # Author:: Yann Azoury
  # Version:: 17
  # Last Update:: 2012-05-19 23:29:44 UTC
  # Status:: Validation Pending


  def help

    @user_actions = Access.where(:table_sid => "uncatched_exceptions", :action_sid => ["index", "list", "show", "destroy", "search", "download", "feed", "help", "adv_search", "create_error"]).includes([:user_accesses, :profile_accesses]).reject{|a| @current_user.can_run?(a) }
    render(:layout => !request.xhr?)
  end


  # Make complex queries.
  #
  # Author:: Yann Azoury
  # Version:: 7
  # Last Update:: 2010-05-27 12:12:45 UTC
  # Status:: Validation Pending


  def adv_search

    redirect_to :action => :search
  end


  # This will test the uncatched exception module.
  #
  #--
  # FIXME: this action does not work correctly
  #++
  # Author:: Sylvain Abélard
  # Version:: 2
  # Last Update:: 2010-06-15 19:10:23 UTC
  # Status:: Does not work


  def create_error

    UncatchedException.find(0) #  no id == 0
    redirect_to(:action => :list)
  end
  protected
  private


  def faveod_cookies_loading
    @pres_mode = cookies["#{APP_SID}_uncatched_exceptions_pres_mode"].to_sym unless cookies["#{APP_SID}_uncatched_exceptions_pres_mode"].blank?
    @pres_mode = params["#{APP_SID}_uncatched_exceptions_pres_mode"].to_sym unless params["#{APP_SID}_uncatched_exceptions_pres_mode"].blank?
  end

end
