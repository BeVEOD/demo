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
## It should be placed at 'test/functional/accesses_controller_test.rb'
## All manual modifications will be destroyed on next generation
################################################


require 'test_helper'

class AccessesControllerTest < ActionController::TestCase
  test "Index responds successfully" do
    get :index
    assert_response :success
    assert_select 'html' do
      assert_select 'body'
      assert_select 'div#content'
    end
  end
end
