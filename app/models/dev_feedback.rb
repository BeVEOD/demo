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
## This has been generated by Faveod Generator on Fri Oct 18 12:04:12 +0200 2013
## It should be placed at 'app/models/dev_feedback.rb'
## All manual modifications will be destroyed on next generation
################################################


class DevFeedback < ActiveRecord::Base

  self.table_name = 'dev_feedbacks'
  acts_as_nested_set({:parent_column=>"parent_id", :left_column=>"lft", :right_column=>"rgt"})
  SEARCHABLE_FIELDS = [:ticket_status,:title,:text,:url,:controller,:action,:created_at,:user,:ip,:ua,:lft,:parent_id,:rgt].freeze
  RESTRICTED_FIELDS = [].freeze
  FIELDS = HashWithIndifferentAccess.new(:ticket_status => :static_list, :title => :string, :text => :text, :zone => :any_object, :url => :string, :controller => :string, :action => :string, :created_at => :datetime, :user => :bt_assoc, :ip => :string, :ua => :string, :browser => :any_object, :parent_id => :nested_set).freeze
  COMPARATORS = {:ticket_status => ActiveSupport::OrderedHash['=', ["dev_feedbacks.ticket_status = ?"], '!=', ["dev_feedbacks.ticket_status <> ?"], 'NULL', ["dev_feedbacks.ticket_status IS NULL", ''], 'NOT_NULL', ["dev_feedbacks.ticket_status IS NOT NULL", '']],
    :title => ActiveSupport::OrderedHash['=~', ["dev_feedbacks.title LIKE ?", '%%%s%'], '!~', ["dev_feedbacks.title NOT LIKE ?", '%%%s%'], '^=', ["dev_feedbacks.title LIKE ?", '%s%'], '$=', ["dev_feedbacks.title LIKE ?", '%%%s'], '=', ["dev_feedbacks.title = ?"], '!=', ["dev_feedbacks.title <> ?"], 'NULL', ["dev_feedbacks.title IS NULL", ''], 'NOT_NULL', ["dev_feedbacks.title IS NOT NULL", '']],
    :text => ActiveSupport::OrderedHash['=~', ["dev_feedbacks.text LIKE ?", '%%%s%'], '!~', ["dev_feedbacks.text NOT LIKE ?", '%%%s%'], '^=', ["dev_feedbacks.text LIKE ?", '%s%'], '$=', ["dev_feedbacks.text LIKE ?", '%%%s'], '=', ["dev_feedbacks.text = ?"], '!=', ["dev_feedbacks.text <> ?"], 'NULL', ["dev_feedbacks.text IS NULL", ''], 'NOT_NULL', ["dev_feedbacks.text IS NOT NULL", '']],
    :zone => ActiveSupport::OrderedHash['=~', ["dev_feedbacks.zone LIKE ?", '%%%s%'], '!~', ["dev_feedbacks.zone NOT LIKE ?", '%%%s%']],
    :url => ActiveSupport::OrderedHash['=~', ["dev_feedbacks.url LIKE ?", '%%%s%'], '!~', ["dev_feedbacks.url NOT LIKE ?", '%%%s%'], '^=', ["dev_feedbacks.url LIKE ?", '%s%'], '$=', ["dev_feedbacks.url LIKE ?", '%%%s'], '=', ["dev_feedbacks.url = ?"], '!=', ["dev_feedbacks.url <> ?"], 'NULL', ["dev_feedbacks.url IS NULL", ''], 'NOT_NULL', ["dev_feedbacks.url IS NOT NULL", '']],
    :controller => ActiveSupport::OrderedHash['=~', ["dev_feedbacks.controller LIKE ?", '%%%s%'], '!~', ["dev_feedbacks.controller NOT LIKE ?", '%%%s%'], '^=', ["dev_feedbacks.controller LIKE ?", '%s%'], '$=', ["dev_feedbacks.controller LIKE ?", '%%%s'], '=', ["dev_feedbacks.controller = ?"], '!=', ["dev_feedbacks.controller <> ?"], 'NULL', ["dev_feedbacks.controller IS NULL", ''], 'NOT_NULL', ["dev_feedbacks.controller IS NOT NULL", '']],
    :action => ActiveSupport::OrderedHash['=~', ["dev_feedbacks.action LIKE ?", '%%%s%'], '!~', ["dev_feedbacks.action NOT LIKE ?", '%%%s%'], '^=', ["dev_feedbacks.action LIKE ?", '%s%'], '$=', ["dev_feedbacks.action LIKE ?", '%%%s'], '=', ["dev_feedbacks.action = ?"], '!=', ["dev_feedbacks.action <> ?"], 'NULL', ["dev_feedbacks.action IS NULL", ''], 'NOT_NULL', ["dev_feedbacks.action IS NOT NULL", '']],
    :created_at => ActiveSupport::OrderedHash['=', ["dev_feedbacks.created_at = ?"], '!=', ["dev_feedbacks.created_at <> ?"], '>', ["dev_feedbacks.created_at > ?"], '<', ["dev_feedbacks.created_at < ?"], '>=', ["dev_feedbacks.created_at >= ?"], '<=', ["dev_feedbacks.created_at <= ?"]],
    :created_at_min => ActiveSupport::OrderedHash['>=', ["dev_feedbacks.created_at >= ?"], '>', ["dev_feedbacks.created_at > ?"]],
    :created_at_max => ActiveSupport::OrderedHash['<=', ["dev_feedbacks.created_at <= ?"], '<', ["dev_feedbacks.created_at < ?"]],
    :user => ActiveSupport::OrderedHash['=', ["dev_feedbacks.user_id = ?"], '!=', ["dev_feedbacks.user_id <> ?"], 'NULL', ["dev_feedbacks.user_id IS NULL", ''], 'NOT_NULL', ["dev_feedbacks.user_id IS NOT NULL", '']],
    :user_id => ActiveSupport::OrderedHash['=', ["dev_feedbacks.user_id = ?"], '!=', ["dev_feedbacks.user_id <> ?"], 'NULL', ["dev_feedbacks.user_id IS NULL", ''], 'NOT_NULL', ["dev_feedbacks.user_id IS NOT NULL", '']],
    :ip => ActiveSupport::OrderedHash['=~', ["dev_feedbacks.ip LIKE ?", '%%%s%'], '!~', ["dev_feedbacks.ip NOT LIKE ?", '%%%s%'], '^=', ["dev_feedbacks.ip LIKE ?", '%s%'], '$=', ["dev_feedbacks.ip LIKE ?", '%%%s'], '=', ["dev_feedbacks.ip = ?"], '!=', ["dev_feedbacks.ip <> ?"], 'NULL', ["dev_feedbacks.ip IS NULL", ''], 'NOT_NULL', ["dev_feedbacks.ip IS NOT NULL", '']],
    :ua => ActiveSupport::OrderedHash['=~', ["dev_feedbacks.ua LIKE ?", '%%%s%'], '!~', ["dev_feedbacks.ua NOT LIKE ?", '%%%s%'], '^=', ["dev_feedbacks.ua LIKE ?", '%s%'], '$=', ["dev_feedbacks.ua LIKE ?", '%%%s'], '=', ["dev_feedbacks.ua = ?"], '!=', ["dev_feedbacks.ua <> ?"], 'NULL', ["dev_feedbacks.ua IS NULL", ''], 'NOT_NULL', ["dev_feedbacks.ua IS NOT NULL", '']],
    :browser => ActiveSupport::OrderedHash['=~', ["dev_feedbacks.browser LIKE ?", '%%%s%'], '!~', ["dev_feedbacks.browser NOT LIKE ?", '%%%s%']],
    :parent_id => ActiveSupport::OrderedHash['=', ["dev_feedbacks.parent_id = ?"], '!=', ["dev_feedbacks.parent_id <> ?"], '>', ["dev_feedbacks.parent_id > ?"], '<', ["dev_feedbacks.parent_id < ?"], '>=', ["dev_feedbacks.parent_id >= ?"], '<=', ["dev_feedbacks.parent_id <= ?"]],
    :parent_id_min => ActiveSupport::OrderedHash['>=', ["dev_feedbacks.parent_id >= ?"], '>', ["dev_feedbacks.parent_id > ?"]],
  :parent_id_max => ActiveSupport::OrderedHash['<=', ["dev_feedbacks.parent_id <= ?"], '<', ["dev_feedbacks.parent_id < ?"]]}.freeze
  WINDOWS_VERSIONS = {
    "NT 6.1"	=> "7",
    "NT 6.0"	=> "Vista",
    "NT 5.2"	=> "XP x64 Edition",
    "NT 5.1"	=> "XP",
    "NT 5.01"	=> "2000, Service Pack 1 (SP1)",
    "NT 5.0"	=> "2000",
    "NT 4.0"	=> "NT 4.0",
    "98"	=> "98",
    "95"	=> "95",
    "CE"	=> "CE"
  }
  TICKET_STATUSES = ["OPN - Open", "ACK - Acknowledged", "WRK - Working", "CMT - Waiting comments", "MOR - More information needed", "MNG - Requires choice", "OK - Solved", "DUP - Duplicate", "NXT - Planned for a next version", "WNT - Wontfix", "CLS - Closed"]
  LOCALIZED_TICKET_STATUSES = [_("OPN - Open"), _("ACK - Acknowledged"), _("WRK - Working"), _("CMT - Waiting comments"), _("MOR - More information needed"), _("MNG - Requires choice"), _("OK - Solved"), _("DUP - Duplicate"), _("NXT - Planned for a next version"), _("WNT - Wontfix"), _("CLS - Closed")]
  FILES_DEST = Rails.root.join('files', %q{dev_feedbacks}).to_s

  serialize(:zone)
  serialize(:browser)


  # == Validations



  # == Triggers


  before_create(:set_browser_detection)

  after_save(:move_to_saved_parent)


  # == Relations
  #


  belongs_to :user, :foreign_key => "user_id", :class_name => "User"


  # Associations through specific setters
  #
  # Virtual Fields

  attr_accessor :future_parent_id
  attr_accessor :user_was

  attr_accessor :ticket_status__index_was

  def self.attribute_condition(quoted_column_name, argument)
    if quoted_column_name[/\.(\'|\`){0,1}(ticket_status)(__index){0,1}(\'|\`){0,1}\Z/]
      %Q[#{quoted_column_name.sub('__index', '')} = ?]
    else
      case argument
      when nil   then "#{quoted_column_name} IS ?"
      when Array, ActiveRecord::Associations::AssociationCollection, ActiveRecord::NamedScope::Scope then "#{quoted_column_name} IN (?)"
      when Range
        if argument.exclude_end?
          "#{quoted_column_name} >= ? AND #{quoted_column_name} < ?"
        else
          "#{quoted_column_name} BETWEEN ? AND ?"
        end
      else            "#{quoted_column_name} = ?"
      end
    end
  end


  # == Methods
  #



  # Load the matching object with right attributes.
  #
  # Author:: Sylvain Abélard
  # Version:: 53
  # Last Update:: 2013-09-03 16:56:08 UTC
  # Status:: Validated


  def self.load_from_params(att)
    return DevFeedback.new if att.blank?
    std_atts = att.reject{|k,v| %w(id user).include?(k.to_s) }
    dev_feedback = nil
    if att.has_key?(:id) && att[:id].to_i != 0 # Useful for HasOne (ho_assoc)
      dev_feedback = DevFeedback.find(att[:id])
      dev_feedback.attributes = std_atts
    else
      dev_feedback = DevFeedback.new(std_atts)
    end
    dev_feedback.future_parent_id = std_atts[:parent_id]
    std_atts.reject!{|k,v| %w(parent_id lft rgt).include?(k.to_s) }

    # clean associations

    dev_feedback.user_load_from_params(att[:user])

    #clean binaries
    #clean serialized data

    if att[:zone] && att[:zone].is_a?(String)
      dev_feedback.zone = ActiveSupport::JSON.decode(att[:zone])
    end
    if att[:browser] && att[:browser].is_a?(String)
      dev_feedback.browser = ActiveSupport::JSON.decode(att[:browser])
    end
    return dev_feedback
  end


  # The disp_name is how any record will appear in most use cases, such as lists of associated records during 'show', 'list'...
  #
  # Faveod will try to guess the best single field, based on SID, usually from fields containing "Title", "Name" or "Label".
  #
  # Customized code often will often look like these snippets:
  # Multiple key: "#{self.first_name} #{self.last_name}"
  # Date or time: "#{self.name} #{self.created_at.strftime('%H:%M %y-%m-%d') if self.created_at}"
  # Associations: "#{self.name} #{self.user ? self.user.disp_name : _('No user')}"
  #
  # Author:: Sylvain Abélard
  # Version:: 4
  # Last Update:: 2011-05-31 17:21:54 UTC
  # Status:: Validated


  def disp_name
    self.title || ''
  end


  # Search
  #
  # Author:: Yann Azoury
  # Version:: 23
  # Last Update:: 2011-08-09 11:16:42 UTC
  # Status:: Validation Pending


  def self.search(values, comps=nil, opts={})
    ar_opts = {}
    if values.is_a?(SmartQuery)
      ar_opts = values.to_ar_opts
    else
      cond = {}
      inc = []
      string_h = {'=' => nil, '<>' => :ne, '=~' => :like, '!=~' => :not,
        'LIKE' => :eq, 'NOT LIKE' => :ne, 'STARTS WITH' => :starts_with, 'ENDS WITH' => :ends_with,
      'IS NULL' => nil, 'IN' => nil}
      numb_h = {'=' => nil, '<>' => :ne, '>' => :gt, '<' => :lt, '>=' => :gte, '<=' => :lte, 'IS NULL' => nil, 'IN' => nil}
      date_h = {'=' => nil, '<>' => :ne, '>' => :gt, '<' => :lt, '>=' => :gte, '<=' => :lte, 'IS NULL' => nil, 'IN' => nil}
      bin_h = {'is named' => :eq, 'size larger than' => :gte, 'size smaller than' => :lte, 'is not set' => nil}
      assoc_h = {'<>' => :ne, '=' => nil, 'IN' => nil, 'IS NULL' => nil}
      DevFeedback.new.params_to_attributes(values).each { |k,v|
        case k.to_sym
        when :ticket_status
          cmp = comps["comp_ticket_status"]
          cmp ||= 'LIKE'
          vals = val.is_a?(Enumerable) ? val : v.split(',').map(&:to_i)
          vals = vals.map {|i| found = DevFeedback::TICKET_STATUSES.index(i);
          found ? found + 1 : i}
          val = cmp == 'IS NULL' ? nil : vals
          field = numb_h[cmp].nil? ? :ticket_status : "ticket_status_#{numb_h[cmp]}"
          cond[field] = val
        when :title
          cmp = comps["comp_title"]
          cmp ||= 'STARTS WITH'
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',') : v)
          field = string_h[cmp].nil? ? :title : "title_#{string_h[cmp]}"
          cond[field] = val
        when :text
          cmp = comps["comp_text"]
          cmp ||= 'STARTS WITH'
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',') : v)
          field = string_h[cmp].nil? ? :text : "text_#{string_h[cmp]}"
          cond[field] = val
        when :url
          cmp = comps["comp_url"]
          cmp ||= 'STARTS WITH'
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',') : v)
          field = string_h[cmp].nil? ? :url : "url_#{string_h[cmp]}"
          cond[field] = val
        when :controller
          cmp = comps["comp_controller"]
          cmp ||= 'STARTS WITH'
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',') : v)
          field = string_h[cmp].nil? ? :controller : "controller_#{string_h[cmp]}"
          cond[field] = val
        when :action
          cmp = comps["comp_action"]
          cmp ||= 'STARTS WITH'
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',') : v)
          field = string_h[cmp].nil? ? :action : "action_#{string_h[cmp]}"
          cond[field] = val
        when :created_at
          cmp = comps["comp_created_at"]
          cmp ||= '='
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',') : v)
          field = date_h[cmp].nil? ? :created_at : "created_at_#{date_h[cmp]}"
          cond[field] = val
        when :user_id
          cmp = comps["comp_user_id"]
          cmp ||= 'IN'
          vals  = val.is_a?(Enumerable) ? v : v.split(',').map(&:to_i)
          val   = cmp == 'IS NULL' ? nil : vals
          field = numb_h[cmp].nil? ? :user_id : "user_id_#{numb_h[cmp]}"
          cond[field] = val
        when :ip
          cmp = comps["comp_ip"]
          cmp ||= 'STARTS WITH'
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',') : v)
          field = string_h[cmp].nil? ? :ip : "ip_#{string_h[cmp]}"
          cond[field] = val
        when :ua
          cmp = comps["comp_ua"]
          cmp ||= 'STARTS WITH'
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',') : v)
          field = string_h[cmp].nil? ? :ua : "ua_#{string_h[cmp]}"
          cond[field] = val
        when :parent_id
          cmp = comps["comp_parent_id"]
          cmp ||= '='
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',').map(&:to_i) : v.to_i)
          field = numb_h[cmp].nil? ? :parent_id : "parent_id_#{numb_h[cmp]}"
          cond[field] = val
        when :parent_id
          cmp = comps["comp_parent_id"]
          if cmp == 'IS NULL'
            cond["parent_id"] = nil
          elsif cmp == 'IN'
            dev_feedbacks_parent = DevFeedback.find(v)
            cond["lft_gt"] = dev_feedbacks_parent.lft
            cond["rgt_lt"] = dev_feedbacks_parent.rgt
          else
            cond["parent_id"] = v
          end
        end
      }
      ar_opts = {:conditions => cond}
      ar_opts[:include] = inc unless inc.blank?
    end
    ar_opts[:per_page] = opts[:per_page] ? opts[:per_page] : count(:all, ar_opts)
    ar_opts[:per_page] = 1 if ar_opts[:per_page] == 0
    ar_opts[:page]	   = opts[:page] ? opts[:page] : 1
    paginate(ar_opts)
  end


  # Makes all kind of calculations for reports.
  #
  # Author:: Yann Azoury
  # Version:: 20
  # Last Update:: 2013-02-27 12:27:37 UTC
  # Status:: Should be optimized


  def self.report_calculation(op, field = :id, opts = {})
    scope	= opts[:scope]
    labels	= opts[:labels]	  || []
    step	= opts[:step]
    group	= opts[:group]
    ret_hash= opts[:ret_hash] || false
    opsym	= case op
    when :count, 'count'			then field = :id ; :count
    when :avg, 'avg', 'average', :average	then :avg
    when :value, 'value', :sum, 'sum'	then :sum
    when :min, 'min', :minimum, 'minimum'	then :min
    when :max, 'max', :maximum, 'maximum'	then :max
    else field = :id ; :count
    end
    case group
    when nil
      return scope.blank? ? self.calculate(opsym, field) : with_scope(:find => {:conditions => scope}) { self.calculate(opsym, field) }
    when :user, 'user'
      h = if scope.blank?
        self.calculate(opsym, field, :group => :user_id)
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => :user_id)
        }
      end
      return ret_hash ? h : labels.map{|l| (l.is_a?(Fixnum) ? h[l] : (h[l.id] || h[l.id.to_s])) || 0}

    when :ticket_status, 'ticket_status'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'ticket_status')
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'ticket_status')
        }
      end
      if ret_hash
        return h
      else
        serie = []
        labels.each_with_index{|l,idx| serie << (h[idx+1] || 0)}
        return serie
      end
    when :"users.active", 'users.active'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'users.active', :joins => :user)
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'users.active', :joins => :user)
        }
      end
      if ret_hash
        return h
      else
        serie = []
        labels.each_with_index{|l,idx| serie << (h[idx+1] || 0)}
        return serie
      end
    when :title, 'title'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'title')
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'title')
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :url, 'url'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'url')
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'url')
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :controller, 'controller'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'controller')
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'controller')
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :action, 'action'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'action')
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'action')
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :ip, 'ip'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'ip')
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'ip')
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :ua, 'ua'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'ua')
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'ua')
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :"users.login", 'users.login'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'users.login', :joins => :user)
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'users.login', :joins => :user)
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :"users.first_name", 'users.first_name'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'users.first_name', :joins => :user)
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'users.first_name', :joins => :user)
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :"users.last_name", 'users.last_name'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'users.last_name', :joins => :user)
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'users.last_name', :joins => :user)
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :"users.email", 'users.email'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'users.email', :joins => :user)
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'users.email', :joins => :user)
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :"users.telephone", 'users.telephone'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'users.telephone', :joins => :user)
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'users.telephone', :joins => :user)
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :"users.language", 'users.language'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'users.language', :joins => :user)
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'users.language', :joins => :user)
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :"users.password", 'users.password'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'users.password', :joins => :user)
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'users.password', :joins => :user)
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :"users.hashed_password", 'users.hashed_password'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'users.hashed_password', :joins => :user)
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'users.hashed_password', :joins => :user)
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :"users.salt", 'users.salt'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'users.salt', :joins => :user)
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'users.salt', :joins => :user)
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :"users.last_session_id", 'users.last_session_id'
      h = if scope.blank?
        self.calculate(opsym, field, :group => 'users.last_session_id', :joins => :user)
      else
        self.with_scope(:find => {:conditions => scope}) {
          self.calculate(opsym, field, :group => 'users.last_session_id', :joins => :user)
        }
      end
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :lft, 'lft'
      h = {}
      labels.each_with_index { |l, idx|
        h[l] = if scope.blank?
          self.where(["dev_feedbacks.lft >= ? AND dev_feedbacks.lft < ?", l, labels[idx+1]]).calculate(opsym, field)
        else
          self.with_scope(:find => {:conditions => scope}) {
            self.where(["dev_feedbacks.lft >= ? AND dev_feedbacks.lft < ?", l, labels[idx+1]]).calculate(opsym, field)
          }
        end
      }
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :parent_id, 'parent_id'
      h = {}
      labels.each_with_index { |l, idx|
        h[l] = if scope.blank?
          self.where(["dev_feedbacks.parent_id >= ? AND dev_feedbacks.parent_id < ?", l, labels[idx+1]]).calculate(opsym, field)
        else
          self.with_scope(:find => {:conditions => scope}) {
            self.where(["dev_feedbacks.parent_id >= ? AND dev_feedbacks.parent_id < ?", l, labels[idx+1]]).calculate(opsym, field)
          }
        end
      }
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :rgt, 'rgt'
      h = {}
      labels.each_with_index { |l, idx|
        h[l] = if scope.blank?
          self.where(["dev_feedbacks.rgt >= ? AND dev_feedbacks.rgt < ?", l, labels[idx+1]]).calculate(opsym, field)
        else
          self.with_scope(:find => {:conditions => scope}) {
            self.where(["dev_feedbacks.rgt >= ? AND dev_feedbacks.rgt < ?", l, labels[idx+1]]).calculate(opsym, field)
          }
        end
      }
      return ret_hash ? h : labels.map{|l| h[l] || 0}
    when :created_at, 'created_at'
      if opts[:period]
        lab_format = ""
        pgroup = case opts[:period].to_sym
        when :day
          lab_format = '%Y-%m-%d'
          "DATE(dev_feedbacks.created_at)"
        when :week
          lab_format = '%Y-%W'
          "CONCAT(YEAR(dev_feedbacks.created_at),'-', WEEK(dev_feedbacks.created_at))"
        when :month
          lab_format = '%Y-%m'
          "CONCAT(YEAR(dev_feedbacks.created_at),'-', MONTH(dev_feedbacks.created_at))"
        when :year
          lab_format = '%Y'
          "YEAR(dev_feedbacks.created_at)"
        end
        h = if scope.blank?
          self.calculate(opsym, field, :group => pgroup, :order => 'created_at')
        else
          self.with_scope(:find => {:conditions => scope}) {
            self.calculate(opsym, field, :group => pgroup, :order => 'created_at')
          }
        end
        return ret_hash ? h : labels.map{|l| h[l.strftime(lab_format)] || 0}
      else
        h = {}
        labels.each_with_index { |l, idx|
          h[l] = if scope.blank?
            self.where(["dev_feedbacks.#{group} >= ? AND dev_feedbacks.#{group} < ?", l, labels[idx+1]]).calculate(opsym, field)
          else
            self.with_scope(:find => {:conditions => scope}) {
              self.where(["dev_feedbacks.#{group} >= ? AND dev_feedbacks.#{group} < ?", l, labels[idx+1]]).calculate(opsym, field)
            }
          end
        }
        return ret_hash ? h : labels.map{|l| h[l] || 0}
      end
    when :"users.last_login", 'users.last_login'
      if opts[:period]
        lab_format = ""
        pgroup = case opts[:period].to_sym
        when :day
          lab_format = '%Y-%m-%d'
          "DATE(users.last_login)"
        when :week
          lab_format = '%Y-%W'
          "CONCAT(YEAR(users.last_login),'-', WEEK(users.last_login))"
        when :month
          lab_format = '%Y-%m'
          "CONCAT(YEAR(users.last_login),'-', MONTH(users.last_login))"
        when :year
          lab_format = '%Y'
          "YEAR(users.last_login)"
        end
        h = if scope.blank?
          self.calculate(opsym, field, :group => pgroup, :order => 'users.last_login', :joins => :user)
        else
          self.with_scope(:find => {:conditions => scope}) {
            self.calculate(opsym, field, :group => pgroup, :order => 'users.last_login', :joins => :user)
          }
        end
        return ret_hash ? h : labels.map{|l| h[l.strftime(lab_format)] || 0}
      else
        h = {}
        labels.each_with_index { |l, idx|
          h[l] = if scope.blank?
            self.where(["dev_feedbacks.#{group} >= ? AND dev_feedbacks.#{group} < ?", l, labels[idx+1]]).calculate(opsym, field)
          else
            self.with_scope(:find => {:conditions => scope}) {
              self.where(["dev_feedbacks.#{group} >= ? AND dev_feedbacks.#{group} < ?", l, labels[idx+1]]).calculate(opsym, field)
            }
          end
        }
        return ret_hash ? h : labels.map{|l| h[l] || 0}
      end
    else
      logger.debug("Unknown Group: #{group} (operation: #{opsym}, scope: #{scope})")
    end
    return []
  end


  # Import maps elements from KML format.
  #
  # Author:: Yann Azoury
  # Version:: 2
  # Last Update:: 2012-10-18 22:14:54 UTC
  # Status:: Validated


  def self.from_kml(path)
    doc = Nokogiri::XML(File.read(path))
    doc.css('Placemark').each {|l|
      pi = l.css('Data[name=Name] value')[0].content.strip
      country = DevFeedback.find_by_name(pi)
      poly = l.css('Polygon').to_a.flatten.map{|p|
        p.content.gsub(/,0\.0/, ',').split(',').map(&:to_f)
      }.flatten
      (poly.length / 2).times{
        country.devfeedback_borders.create(:lat => poly.shift, :lng => poly.shift)
      }
    }
  end


  # Nested Sets: gets the tree root.
  #
  # Author:: Sylvain Abélard
  # Version:: 10
  # Last Update:: 2010-06-16 14:36:10 UTC
  # Status:: Validated


  def self.get_root(opts = {})
    root = DevFeedback.new
    root.id = 0
    @@root_options = opts

    def root.children(options = @@root_options)
      options[:conditions] = options[:conditions] ? options[:conditions].merge(:parent_id => nil) : {:parent_id => nil}
      options[:order] ||= :lft
      return DevFeedback.all(options)
    end
    return root
  end


  # Nested Sets: possible parents.
  #
  # Author:: Sylvain Abélard
  # Version:: 3
  # Last Update:: 2010-06-16 14:36:32 UTC
  # Status:: Validated


  def parent__potential_values
    if self.new_record?
      DevFeedback.all(:order => :lft)
    else
      DevFeedback.all(:conditions => ["rgt < ? OR lft > ? OR (lft < ? AND rgt > ?)", self.lft, self.rgt, self.lft, self.rgt], :order => :lft)
    end
  end


  # Use @parent_id created by load_from_params.
  #
  # Author:: Yann Azoury
  # Version:: 6
  # Last Update:: 2010-03-18 18:58:35 UTC
  # Status:: Validated


  def move_to_saved_parent

    if !@future_parent_id.nil?
      if @future_parent_id.blank? || @future_parent_id.to_i == 0
        self.move_to_root
      else
        self.move_to_child_of(@future_parent_id)
      end
    end
  end


  # Return the previous element.
  #
  # Author:: Yann Azoury
  # Version:: 1
  # Last Update:: 2009-09-14 14:48:02 UTC
  # Status:: Validated


  def previous

    DevFeedback.first(:order => 'lft DESC', :conditions => ["lft < ?", self.lft])
  end


  # Returns next element.
  #
  # Author:: Yann Azoury
  # Version:: 1
  # Last Update:: 2010-04-02 13:10:22 UTC
  # Status:: Validated


  def next

    DevFeedback.first(:order => :lft, :conditions => ["lft > ?", self.lft])
  end

  # Author:: Sylvain Abélard
  # Version:: 2
  # Last Update:: 2011-07-04 15:00:42 UTC


  def self.named_scope_open_method
    {:conditions => ["ticket_status < ?", 7]}
  end

  scope(:open, proc { named_scope_open_method })

  # Author:: Sylvain Abélard
  # Version:: 2
  # Last Update:: 2011-07-04 15:00:27 UTC


  def self.named_scope_just_opened_method
    {:conditions => ["ticket_status < ?", 2]}
  end

  scope(:just_opened, proc { named_scope_just_opened_method })

  # Author:: Sylvain Abélard
  # Version:: 3
  # Last Update:: 2011-07-04 15:04:00 UTC


  def self.named_scope_pending_method
    {:conditions => ["ticket_status < ?", 7]}
  end

  scope(:pending, proc { named_scope_pending_method })

  # Author:: Sylvain Abélard
  # Version:: 1
  # Last Update:: 2011-07-04 14:53:07 UTC


  def self.named_scope_closing_method
    {:conditions => ["ticket_status > ? AND ticket_status < ?", 6, 11]}
  end

  scope(:closing, proc { named_scope_closing_method })

  # Author:: Sylvain Abélard
  # Version:: 1
  # Last Update:: 2011-07-04 14:56:04 UTC


  def self.named_scope_closed_method
    {:conditions => ["ticket_status > ?", 10]}
  end

  scope(:closed, proc { named_scope_closed_method })

  # Author:: Sylvain Abélard
  # Version:: 2
  # Last Update:: 2011-07-07 15:25:16 UTC


  def self.named_scope_for_page_method(params)
    if params
      conds = {}
      conds[:controller]	= params[:controller]	unless params[:controller].blank?
      conds[:action]	= params[:action]	unless params[:action].blank?
      {:conditions => conds}
    else
      {}
    end
  end

  scope(:for_page, proc {|params| named_scope_for_page_method(params) })

  # Author:: Sylvain Abélard
  # Version:: 2
  # Last Update:: 2011-07-04 19:23:41 UTC


  def self.named_scope_for_user_method(user)
    if user
      if user.is_admin?
        {}
      else
        {:conditions => {:user_id => user.id}}
      end
    else
      {:conditions => {:id => 0}}
    end
  end

  scope(:for_user, proc {|user| named_scope_for_user_method(user) })

  # Author:: Yann Azoury
  # Version:: 5
  # Last Update:: 2009-11-01 16:01:43 UTC


  def self.named_scope_default_scope_method

    {:order => 'lft'}
  end

  default_scope(named_scope_default_scope_method())

  # Author:: Yann Azoury
  # Version:: 9
  # Last Update:: 2013-02-03 20:51:21 UTC


  def self.named_scope_active_filter_method(hash)

    #hash looks like {'field1' => {'op' => value}, 'field2' => ... }
    #op could be =, !=, ^=, $=, =~, !~, >, <, >=, <=, IN, FTS...

    hash ||= {}
    values = []
    joins_fields = []
    _scopes = nil
    if !hash['_scopes'].blank?
      (%w() & hash['_scopes']).each{|s|
        _scopes = (_scopes || self).send(s.to_sym)
      }
    end
    str = hash.map{|field, pairs|
      if [:ticket_status, :title, :text, :zone, :url, :controller, :action, :created_at, :user, :user_id, :ip, :ua, :browser, :lft, :parent_id, :rgt
      ].include?(field.to_sym)
      Array(pairs).map do |op,val|
        cmp = COMPARATORS[field.to_sym][op]
        values << (cmp.length == 1 ? val : (cmp[1] % val)) unless cmp[1] && cmp[1] == ''
        cmp[0]
      end
    elsif [
    ].include?(field.to_sym)
    Array(pairs).map do |op,val|
      cmp = COMPARATORS[field.to_sym][op]
      values += Array(val)
      "(%s)" % val.map{|v| cmp[0] }.join(' OR ')
    end
  end
}.compact.flatten.join(' AND ')
if _scopes
  return _scopes.proxy_options if values.blank?
  return _scopes.joins(joins_fields).where(values.insert(0, str)).proxy_options
else
  res = joins_fields.blank? ? {} : {:joins => joins_fields}
  res[:conditions] = values.insert(0, str)
  return res
end
end

scope(:active_filter, proc {|hash| named_scope_active_filter_method(hash) })


# Author:: Sylvain Abélard
# Version:: 3
# Last Update:: 2011-07-04 12:40:46 UTC
# Status:: In Progress


def self.active?(opts={})
return false unless SystemSetting.true?('dev_feedbacks')
return false unless opts[:user]
return true if opts[:user].is_admin?
false
end


# Author:: Sylvain Abélard
# Version:: 3
# Last Update:: 2011-07-08 20:21:08 UTC
# Status:: Validation Pending


def self.available(opts={})
DevFeedback.for_user(opts[:user]).for_page(opts[:params])
end


# Author:: Sylvain Abélard
# Version:: 2
# Last Update:: 2011-07-07 15:30:41 UTC
# Status:: Validated


def disp_class

"dev_feedback status_#{self.ticket_status__index || 0}"
end


# Author:: Yann Azoury
# Version:: 8
# Last Update:: 2011-07-07 20:00:32 UTC
# Status:: Validation Pending


def self.browser_detection(user_agent)
ua = user_agent.downcase
res = {
  :platform	=> nil,
  :engine	=> nil,
  :browser	=> nil,
  :mobile	=> nil
}
(%w(iphone ipod ipad)).each {|p|
  if ua =~ /#{p}/
    res[:platform]	= 'iOS'
    res[:engine]	= 'WebKit'
    res[:browser]	= 'Mobile Safari'
    res[:mobile]	= true
  end
}
(%w(blackberry android webos symbian psp)).each {|p|
  if ua =~ /#{p}/
    res[:platform]	= Regexp.last_match.first
    res[:mobile]	= true
  end
}
(%w(opera konqueror)).each {|p|
  if ua =~ /#{p}/
    res[:engine]	= Regexp.last_match.first
    res[:browser]	= Regexp.last_match.first
  end
}
(%w(windows macintosh linux ios)).each {|p|
  if ua =~ /#{p}/
    res[:platform]	||= Regexp.last_match.first
  end
}
(%w(googlebot msnbot yahoobot slurp robot)).each {|p|
  if ua =~ /#{p}/
    res[:platform]	= 'Bot'
    res[:browser]	= Regexp.last_match.first
  end
}
if ua =~ /(msie) (\d+\.?\d+)/

  #    ver =

  res[:engine]	= 'IE'
  res[:browser]	= "IE #{Regexp.last_match.last}"
end
if res[:platform] == 'windows'
  ua =~ /windows (95|98|ce|nt|phone os)( \d+\.?\d+)?/
  ver = Regexp.last_match.to_a[1..-1].join.upcase
  if Regexp.last_match[1] == 'phone os'
    res[:platform] = "Windows #{ver}"
    res[:mobile] = true
  else
    res[:platform] = "Windows #{DevFeedback::WINDOWS_VERSIONS[ver]}"
  end
end
res[:engine] ||= 'gecko' if ua =~ /gecko/
res[:browser] ||= 'FireFox' if res[:engine] == 'gecko' && ua =~ /mozilla/
if ua =~ /applewebkit/
  res[:engine]	= 'WebKit'
  res[:browser]	= 'Safari'
end
res[:browser]	||= '?'
res
end


# Author:: Sylvain Abélard
# Version:: 2
# Last Update:: 2011-07-07 15:26:10 UTC
# Status:: Validation Pending


def set_browser_detection
if self.ua && self.browser.blank?
  self.browser = DevFeedback.browser_detection(self.ua)
end
end

# useful method


def user_human_display

return user ? user.disp_name : ""

end


def self.assoc_sids_to_columns(attrs)
h = attrs.has_key?(:conditions) ? attrs[:conditions] : attrs

h[:user_id] = h.delete(:user) if h.has_key?(:user)

if attrs.has_key?(:conditions)
  attrs[:conditions] = h
  attrs
else
  h
end
end


#== Field Logics



# Returns translated string value.
#
# Author:: Yann Azoury
# Version:: 4
# Last Update:: 2013-03-21 11:35:21 UTC
# Status:: Validated


def ticket_status(t = false)
return nil if read_attribute(:ticket_status).nil? || read_attribute(:ticket_status) == 0
return t ? _(TICKET_STATUSES[(read_attribute(:ticket_status)) - 1].to_s) : TICKET_STATUSES[(read_attribute(:ticket_status)) - 1].to_s
end


# Returns the 1-based index(es).
#
# Author:: Yann Azoury
# Version:: 1
# Last Update:: 2010-01-18 00:13:42 UTC
# Status:: Validated


def ticket_status__index
return read_attribute(:ticket_status)
end


# Returns the potential values for this list.
#
# Author:: Yann Azoury
# Version:: 2
# Last Update:: 2011-08-09 11:09:07 UTC
# Status:: Validated


def ticket_status__potential_values(current_user = nil)
TICKET_STATUSES
end


# Flexible setter for the static list.
#
# Author:: Yann Azoury
# Version:: 12
# Last Update:: 2013-09-03 16:56:09 UTC
# Status:: Validated


def ticket_status=(val)

self.ticket_status__index_was = self.ticket_status__index
case val
when nil
  write_attribute(:ticket_status, nil)
when 1..11 # index
  write_attribute(:ticket_status, val)
when "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11" # index as string
  write_attribute(:ticket_status, val.to_i)
when *(self.ticket_status__potential_values) # value
  write_attribute(:ticket_status, self.ticket_status__potential_values.index(val) + 1)
when *LOCALIZED_TICKET_STATUSES # localized value
  write_attribute(:ticket_status, LOCALIZED_TICKET_STATUSES.index(val) + 1)
else
  write_attribute(:ticket_status, nil)
end
end


# Author:: Yann Azoury
# Version:: 3
# Last Update:: 2012-03-19 01:57:30 UTC
# Status:: Validated


def user__potential_values(options = {})
if options.has_key?(:page)
  User.paginate(options)
else
  User.all(options)
end
end


# Load association from different params formats.
#
# Version::
# Last Update:: 2013-08-17 13:22:16 UTC
# Status:: Validated


def user_load_from_params(val)

self.user_was = self.user if val
case val
when Hash, HashWithIndifferentAccess
  self.user = val.map {|k, v|
    if k[/\A(_|-)\d+/] # CREATE
      elt = User.load_from_params(v)
      if !elt.valid?
        self.errors.add(:user, _("Invalid user: %{d}") % {:d => elt.errors.full_messages.join(',')})
      end
      elt
    elsif v.is_a? String # UNCHANGED OR DESTROY
      if v == "-1" #DESTROY
        self.user.destroy(k) unless k.to_i == 0
        val.delete(k)
        nil
      else
        User.find(k) unless k.to_i == 0
      end
    else
      elt = User.load_from_params(v.merge(:id => k))
      if elt.valid?
        elt.save if elt.changed?
      else
        self.errors.add(:user, _("Invalid user: %{d}") % {:d => elt.errors.full_messages.join(',')})
      end
      elt
    end
  }.compact.first
when String, Fixnum
  self.user = val.blank? ? nil : User.find(val)
when nil
else logger.warn("Unexpected params type for 'user': #{val.class}")
end
end

# BINARIES CONSTANTS


end