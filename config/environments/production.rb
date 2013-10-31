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
## This has been generated by Faveod Generator on Wed Sep 11 14:33:56 +0200 2013
## It should be placed at 'config/environments/production.rb'
## All manual modifications will be destroyed on next generation
################################################


DemoApp::Application.configure do

  # Settings specified here will take precedence over those in config/application.rb



  # Show full error reports and disable caching

  config.consider_all_requests_local       = false

  config.action_controller.perform_caching = true


  # In the development environment your application's code is reloaded on every request. This slows down response time but is perfect for development since you don't have to restart the webserver when you make code changes.

  config.cache_classes = true

  # Send deprecation notices to registered listeners

  config.active_support.deprecation = :notify

  # threadsafe! enables allow_concurrency, cache_classes, dependency_loading and preload_frameworks to make the application threadsafe.

  config.threadsafe!

  # Whether or not errors should be raised if the email fails to be delivered.

  config.action_mailer.raise_delivery_errors = true

  #

  config.consider_all_requests_local = false

end
