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
## This has been generated by Faveod Generator on Mon Jul 08 14:03:08 +0200 2013
## It should be placed at 'app/controllers/profile_accesses_controller.rb'
## All manual modifications will be destroyed on next generation
################################################


class ProfileAccessesController < ApplicationController
  layout 'application_jquery_horizontal'

  before_filter(:faveod_cookies_loading)


  # AJAX association management.
  #
  # Author:: Sylvain Abélard
  # Version:: 11
  # Last Update:: 2011-06-23 17:57:01 UTC
  # Status:: Requires Tests


  def linker

    render(:text => _('AJAX only')) and return if !request.xhr?
    render(:text => _('Missing required parameter')) and return if params[:id].blank? || params[:sid].blank?
    params[:page] = 1 if params[:page].to_i == 0
    params[:per_page] = 15 if params[:per_page].to_i == 0
    @profile_access   = ProfileAccess.find_by_id(params[:id])
    @profile_access ||= ProfileAccess.new
    case params[:sid].to_sym
    when :profile
      val = params["profile"] ? params["profile"]["0"] : {}
      @profile = Profile.search(val, params.reject{|k,v| !k[/comp_/]}, :page => params[:page], :per_page => params[:per_page])
      render :partial => '/profiles/list_for_linker', :locals => {:assoc_sid => :profile_accesses, :assoc_type => :belongs_to}
    when :access
      val = params["access"] ? params["access"]["0"] : {}
      @access = Access.search(val, params.reject{|k,v| !k[/comp_/]}, :page => params[:page], :per_page => params[:per_page])
      render :partial => '/accesses/list_for_linker', :locals => {:assoc_sid => :profile_accesses, :assoc_type => :belongs_to}
    end
  end

  protected
  private


  def faveod_cookies_loading
    @pres_mode = cookies["#{APP_SID}_profile_accesses_pres_mode"].to_sym unless cookies["#{APP_SID}_profile_accesses_pres_mode"].blank?
    @pres_mode = params["#{APP_SID}_profile_accesses_pres_mode"].to_sym unless params["#{APP_SID}_profile_accesses_pres_mode"].blank?
  end

end
