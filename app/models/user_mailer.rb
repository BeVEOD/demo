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
## This has been generated by Faveod Generator on Thu Oct 31 16:41:16 +0100 2013
## It should be placed at 'app/models/user_mailer.rb'
## All manual modifications will be destroyed on next generation
################################################


class UserMailer < ActionMailer::Base

  # Author:: Yann Azoury
  # Version:: 28
  # Last Update:: 2012-07-17 16:04:55 UTC
  # Status:: Validated


  def account_infos(user,pass)
    @pass = pass
    @user = user
    mail_params = {:to => user.email};
    if String === ("[#{GSS[:app_name]}] Your Member Account Details, #{user.first_name} #{user.last_name}")
      mail_params[:subject] = ("[#{GSS[:app_name]}] Your Member Account Details, #{user.first_name} #{user.last_name}");
    else
      mail_params[:subject] = 'Wrong Subject Type'
    end
    mail_params[:from] = 'support@faveod.com';

    mail_params[:bcc] = 'support@faveod.com';

    mail(mail_params) do |format|

      format.html

      format.text

    end
  end


  # for compatibility with Rails 2.X only


  def self.deliver_account_infos(user,pass)
    account_infos(user,pass).deliver
  end

  def self.create_account_infos(user,pass)
    account_infos(user,pass)
  end

end
