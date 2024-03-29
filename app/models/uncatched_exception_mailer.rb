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
## It should be placed at 'app/models/uncatched_exception_mailer.rb'
## All manual modifications will be destroyed on next generation
################################################


class UncatchedExceptionMailer < ActionMailer::Base

  # Author:: Sylvain Abélard
  # Version:: 11
  # Last Update:: 2010-05-19 15:11:33 UTC
  # Status:: In Progress


  def uncatched_exception(exp, user, par, saved=nil)
    @err = exp
    @params = par
    @saved = saved
    @user = user
    mail_params = {:to => SystemSetting[:error_notification_to_email_adresses] || 'support@faveod.com'};
    if String === "[#{GSS[:app_sid]|| 'No Name'}] Something went wrong in #{par[:controller]} (#{exp.class.name})"
      mail_params[:subject] = ("[#{GSS[:app_sid]|| 'No Name'}] Something went wrong in #{par[:controller]} (#{exp.class.name})");
    else
      mail_params[:subject] = 'Wrong Subject Type'
    end
    mail_params[:from] = SystemSetting[:error_notification_from_email_adress] || 'support@faveod.com';

    headers({"Disposition-Notification-To"=>"support@faveod.com"})

    mail(mail_params) do |format|

      format.html

      format.text

    end
  end


  # for compatibility with Rails 2.X only


  def self.deliver_uncatched_exception(exp, user, par, saved=nil)
    uncatched_exception(exp, user, par, saved=nil).deliver
  end

  def self.create_uncatched_exception(exp, user, par, saved=nil)
    uncatched_exception(exp, user, par, saved=nil).create
  end

end
