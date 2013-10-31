# encoding: utf-8
################################################
## This file and all its content belong to Faveod S.A.S unless a commercial
## contract signed by a representant of Faveod S.A.S states otherwise.
##############
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
################################################
## This has been generated by Faveod Generator on Mon Jul 08 14:03:06 +0200 2013
## It should be placed at 'app/models/profile.rb'
## All manual modifications will be destroyed on next generation
################################################


class Profile < ActiveRecord::Base

  self.table_name = 'profiles'

  SEARCHABLE_FIELDS = [].freeze
  RESTRICTED_FIELDS = [].freeze
  FIELDS = HashWithIndifferentAccess.new(:name => :string, :users => :habtm_assoc, :home_page => :bt_assoc, :profile_accesses => :hm_assoc).freeze
  COMPARATORS = {:name => ActiveSupport::OrderedHash['=~', ["profiles.name LIKE ?", '%%%s%'], '!~', ["profiles.name NOT LIKE ?", '%%%s%'], '^=', ["profiles.name LIKE ?", '%s%'], '$=', ["profiles.name LIKE ?", '%%%s'], '=', ["profiles.name = ?"], '!=', ["profiles.name <> ?"], 'NULL', ["profiles.name IS NULL", ''], 'NOT_NULL', ["profiles.name IS NOT NULL", '']],
    :users => ActiveSupport::OrderedHash['IN', ["profiles_users.user_id IN (?)"], 'NOT_IN', ["profiles_users.user_id NOT IN (?)"]],
    :home_page => ActiveSupport::OrderedHash['=', ["profiles.home_page_id = ?"], '!=', ["profiles.home_page_id <> ?"], 'NULL', ["profiles.home_page_id IS NULL", ''], 'NOT_NULL', ["profiles.home_page_id IS NOT NULL", '']],
    :home_page_id => ActiveSupport::OrderedHash['=', ["profiles.home_page_id = ?"], '!=', ["profiles.home_page_id <> ?"], 'NULL', ["profiles.home_page_id IS NULL", ''], 'NOT_NULL', ["profiles.home_page_id IS NOT NULL", '']],
  :profile_accesses => ActiveSupport::OrderedHash['IN', ["profile_accesses.id IN (?)"], 'NOT_IN', ["profile_accesses.id NOT IN (?)"]]}.freeze

  FILES_DEST = Rails.root.join('files', %q{profiles}).to_s


  # == Validations


  validates_presence_of(:name)
  validates_uniqueness_of(:name)


  # == Triggers



  # == Relations
  #


  has_many :profile_accesses, :foreign_key => "profile_id", :class_name => "ProfileAccess"
  belongs_to :home_page, :foreign_key => "home_page_id", :class_name => "Access"
  has_and_belongs_to_many :users, :foreign_key => "profile_id", :association_foreign_key => "user_id", :join_table => "profiles_users", :class_name => "User"
  has_many :accesses, :source => :access, :through => :profile_accesses


  # Associations through specific setters
  #



  def accesses=(array)
    ids = array.map(&:id)
    ProfileAccess.where(['profile_accesses.profile_id = ? AND profile_accesses.access_id NOT IN (?)', self.id, ids]).select(:id).each(&:destroy)
    profile_access_ids = ProfileAccess.all(:conditions => {:profile_id => self.id, :access_id => ids}, :select => 'access_id').map(&:access_id)
    (ids - profile_access_ids).each{|i|
      ProfileAccess.create(:profile_id => self.id, :access_id => i)
    }
    self.accesses.reload
  end

  # Virtual Fields

  attr_accessor :users_was
  attr_accessor :home_page_was
  attr_accessor :accesses_was
  attr_accessor :profile_accesses_was


  # == Methods
  #



  # Load the matching object with right attributes.
  #
  # Author:: Sylvain Abélard
  # Version:: 53
  # Last Update:: 2013-03-22 09:46:46 UTC
  # Status:: Validated


  def self.load_from_params(att)
    return Profile.new if att.blank?
    std_atts = att.reject{|k,v| %w(id users home_page accesses profile_accesses).include?(k.to_s) }
    profile = nil
    if att.has_key?(:id) && att[:id].to_i != 0 # Useful for HasOne (ho_assoc)
      profile = Profile.find(att[:id])
      profile.attributes = std_atts
    else
      profile = Profile.new(std_atts)
    end

    # clean associations

    val = att[:users]
    profile.users_was = profile.users if val
    case val
    when Hash, HashWithIndifferentAccess
      profile.users = val.map {|k, v|
        if k[/\A(_|-)\d+/] # CREATE
          User.load_from_params(v)
        elsif v.is_a? String # UNCHANGED OR DESTROY
          if v == "-1" #DESTROY
            profile.users.destroy(k) unless k.to_i == 0
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
            profile.errors.add(:users, :users_invalid)
          end
          elt
        end
      }.compact
    when Array
      val = val.compact.map(&:to_i).reject{|v| v == 0}
      profile.users = (val.empty? ? [] : User.find(val))
    when String, Fixnum
      profile.users = val.blank? ? nil : [User.find(val)]
    when nil
    else logger.warn("Unexpected params type for 'users': #{val.class}")
    end
    val = att[:home_page]
    profile.home_page_was = profile.home_page if val
    case val
    when Hash, HashWithIndifferentAccess
      profile.home_page = val.map {|k, v|
        if k[/\A(_|-)\d+/] # CREATE
          Access.load_from_params(v)
        elsif v.is_a? String # UNCHANGED OR DESTROY
          if v == "-1" #DESTROY
            profile.home_page.destroy(k) unless k.to_i == 0
            val.delete(k)
            nil
          else
            Access.find(k) unless k.to_i == 0
          end
        else
          elt = Access.load_from_params(v.merge(:id => k))
          if elt.valid?
            elt.save if elt.changed?
          else
            profile.errors.add(:home_page, :home_page_invalid)
          end
          elt
        end
      }.compact.first
    when String, Fixnum
      profile.home_page = val.blank? ? nil : Access.find(val)
    when nil
    else logger.warn("Unexpected params type for 'home_page': #{val.class}")
    end
    val = att[:accesses]
    profile.accesses_was = profile.accesses if val
    case val
    when Hash, HashWithIndifferentAccess
      profile.accesses = val.map {|k, v|
        if k[/\A(_|-)\d+/] # CREATE
          Access.load_from_params(v)
        elsif v.is_a? String # UNCHANGED OR DESTROY
          if v == "-1" #DESTROY
            profile.accesses.destroy(k) unless k.to_i == 0
            val.delete(k)
            nil
          else
            Access.find(k) unless k.to_i == 0
          end
        else
          elt = Access.load_from_params(v.merge(:id => k))
          if elt.valid?
            elt.save if elt.changed?
          else
            profile.errors.add(:accesses, :accesses_invalid)
          end
          elt
        end
      }.compact
    when Array
      val = val.compact.map(&:to_i).reject{|v| v == 0}
      profile.accesses = (val.empty? ? [] : Access.find(val))
    when String, Fixnum
      profile.accesses = val.blank? ? nil : [Access.find(val)]
    when nil
    else logger.warn("Unexpected params type for 'accesses': #{val.class}")
    end
    val = att[:profile_accesses]
    profile.profile_accesses_was = profile.profile_accesses if val
    case val
    when Hash, HashWithIndifferentAccess
      profile.profile_accesses = val.map {|k, v|
        if k[/\A(_|-)\d+/] # CREATE
          ProfileAccess.load_from_params(v)
        elsif v.is_a? String # UNCHANGED OR DESTROY
          if v == "-1" #DESTROY
            profile.profile_accesses.destroy(k) unless k.to_i == 0
            val.delete(k)
            nil
          else
            ProfileAccess.find(k) unless k.to_i == 0
          end
        else
          elt = ProfileAccess.load_from_params(v.merge(:id => k))
          if elt.valid?
            elt.save if elt.changed?
          else
            profile.errors.add(:profile_accesses, :profile_accesses_invalid)
          end
          elt
        end
      }.compact
    when Array
      val = val.compact.map(&:to_i).reject{|v| v == 0}
      profile.profile_accesses = (val.empty? ? [] : ProfileAccess.find(val))
    when String, Fixnum
      profile.profile_accesses = val.blank? ? nil : [ProfileAccess.find(val)]
    when nil
    else logger.warn("Unexpected params type for 'profile_accesses': #{val.class}")
    end

    #clean binaries


    return profile
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
    self.name || ''
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
      Profile.new.params_to_attributes(values).each { |k,v|

      }
      ar_opts = {:conditions => cond}
      ar_opts[:include] = inc unless inc.blank?
    end
    ar_opts[:per_page] = opts[:per_page] ? opts[:per_page] : count(:all, ar_opts)
    ar_opts[:per_page] = 1 if ar_opts[:per_page] == 0
    ar_opts[:page]	   = opts[:page] ? opts[:page] : 1
    paginate(ar_opts)
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
      country = Profile.find_by_name(pi)
      poly = l.css('Polygon').to_a.flatten.map{|p|
        p.content.gsub(/,0\.0/, ',').split(',').map(&:to_f)
      }.flatten
      (poly.length / 2).times{
        country.profile_borders.create(:lat => poly.shift, :lng => poly.shift)
      }
    }
  end


  # Return the previous element.
  #
  # Author:: Yann Azoury
  # Version:: 1
  # Last Update:: 2009-09-14 14:48:02 UTC
  # Status:: Validated


  def previous

    Profile.first(:order => 'profiles.id DESC', :conditions => ["profiles.id < ?", self.id])
  end


  # Returns next element.
  #
  # Author:: Yann Azoury
  # Version:: 1
  # Last Update:: 2010-04-02 13:10:22 UTC
  # Status:: Validated


  def next

    Profile.first(:order => 'profiles.id', :conditions => ["profiles.id > ?", self.id])
  end

  # Author:: Yann Azoury
  # Version:: 5
  # Last Update:: 2009-11-01 16:01:43 UTC


  def self.named_scope_default_scope_method

    {}
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
      case field.to_sym
      when :users, :profile_id
        joins_fields << :users
      when :profile_accesses, :profile_id
        joins_fields << :profile_accesses
      end
      if [:name, :users, :profile_id, :home_page, :home_page_id, :profile_accesses
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


# Checks authorization.
#
# Author:: Yann Azoury
# Version:: 4
# Last Update:: 2013-02-27 12:31:20 UTC
# Status:: Validated


def can_run?(action)
if action.is_a?(Hash)
  cond = ["accesses.action_sid = ? AND accesses.table_sid = ?", action[:action_sid], action[:table_sid]]
  return self.profile_accesses.where(cond).first(:include => :access)
elsif action.is_a?(Access)
  return ProfileAccess.exists?(:profile_id => self.id, :access_id => action.id)
end
end

# useful method


def users_human_display

return users.map(&:disp_name).to_sentence(:connector => _('and'))

end


# useful method


def home_page_human_display

return home_page ? home_page.disp_name : ""

end


# useful method


def accesses_human_display

return accesses ? accesses.disp_name : ""

end


# useful method


def profile_accesses_human_display

return profile_accesses.map(&:disp_name).to_sentence(:connector => _('and'))

end


def self.assoc_sids_to_columns(attrs)
h = attrs.has_key?(:conditions) ? attrs[:conditions] : attrs

h[:home_page_id] = h.delete(:home_page) if h.has_key?(:home_page)

if attrs.has_key?(:conditions)
  attrs[:conditions] = h
  attrs
else
  h
end
end


#== Field Logics



# Importing raw data: string, text, color and any_objects.
#
# Author:: Sylvain Abélard
# Version:: 2
# Last Update:: 2011-06-08 19:24:00 UTC
# Status:: Requires Tests


def name_from_spreadsheet(v, opts={})
v
end


# Exporting: displays raw value
#
# Author:: Sylvain Abélard
# Version:: 4
# Last Update:: 2011-06-09 19:52:49 UTC
# Status:: Validation Pending


def name_to_spreadsheet(opts={})
self.name
end


# Author:: Yann Azoury
# Version:: 3
# Last Update:: 2012-03-19 01:57:30 UTC
# Status:: Validated


def users__potential_values(options = {})
if options.has_key?(:page)
  User.paginate(options)
else
  User.all(options)
end
end


# Exporting associations: listing names of linked objects.
#
# Author:: Sylvain Abélard
# Version:: 8
# Last Update:: 2011-06-15 21:03:45 UTC
# Status:: Requires Tests


def users_to_spreadsheet(opts={})

self.users.map(&:disp_name).join(opts[:join] || ', ')

end


# Importing associations: this is way too tricky to let a machine do an educated guess, so you should specify according to your needs.
#
# Author:: Sylvain Abélard
# Version:: 9
# Last Update:: 2011-06-15 21:09:38 UTC
# Status:: Requires Tests


def users_from_spreadsheet(v, opts={})

if v.blank?
  []
else
  User.find_all_by_name(v)
end
end


# Author:: Yann Azoury
# Version:: 3
# Last Update:: 2012-03-19 01:57:30 UTC
# Status:: Validated


def home_page__potential_values(options = {})
if options.has_key?(:page)
  Access.paginate(options)
else
  Access.all(options)
end
end


# Exporting associations: listing names of linked objects.
#
# Author:: Sylvain Abélard
# Version:: 8
# Last Update:: 2011-06-15 21:03:45 UTC
# Status:: Requires Tests


def home_page_to_spreadsheet(opts={})

(self.home_page.blank? ? '' : self.home_page.disp_name)

end


# Importing associations: this is way too tricky to let a machine do an educated guess, so you should specify according to your needs.
#
# Author:: Sylvain Abélard
# Version:: 9
# Last Update:: 2011-06-15 21:09:38 UTC
# Status:: Requires Tests


def home_page_from_spreadsheet(v, opts={})

if v.blank?
  nil
else
  Access.find_by_name(v)
end

end


# Exporting no data: displays the field name
#
# Author:: Sylvain Abélard
# Version:: 3
# Last Update:: 2011-06-08 18:34:35 UTC
# Status:: Validation Pending


def access_management_to_spreadsheet(opts={})
_(%q{Access Management})
end


# Author:: Yann Azoury
# Version:: 3
# Last Update:: 2012-03-19 01:57:30 UTC
# Status:: Validated


def accesses__potential_values(options = {})
if options.has_key?(:page)
  Access.paginate(options)
else
  Access.all(options)
end
end


# Exporting associations: listing names of linked objects.
#
# Author:: Sylvain Abélard
# Version:: 8
# Last Update:: 2011-06-15 21:03:45 UTC
# Status:: Requires Tests


def accesses_to_spreadsheet(opts={})

self.accesses.map(&:disp_name).join(opts[:join] || ', ')

end


# Importing associations: this is way too tricky to let a machine do an educated guess, so you should specify according to your needs.
#
# Author:: Sylvain Abélard
# Version:: 9
# Last Update:: 2011-06-15 21:09:38 UTC
# Status:: Requires Tests


def accesses_from_spreadsheet(v, opts={})

if v.blank?
  []
else
  Access.find_all_by_name(v)
end
end


# Author:: Yann Azoury
# Version:: 3
# Last Update:: 2012-03-19 01:57:30 UTC
# Status:: Validated


def profile_accesses__potential_values(options = {})
if options.has_key?(:page)
  ProfileAccess.paginate(options)
else
  ProfileAccess.all(options)
end
end


# Exporting associations: listing names of linked objects.
#
# Author:: Sylvain Abélard
# Version:: 8
# Last Update:: 2011-06-15 21:03:45 UTC
# Status:: Requires Tests


def profile_accesses_to_spreadsheet(opts={})

self.profile_accesses.map(&:disp_name).join(opts[:join] || ', ')

end


# Importing associations: this is way too tricky to let a machine do an educated guess, so you should specify according to your needs.
#
# Author:: Sylvain Abélard
# Version:: 9
# Last Update:: 2011-06-15 21:09:38 UTC
# Status:: Requires Tests


def profile_accesses_from_spreadsheet(v, opts={})

if v.blank?
  []
else
  ProfileAccess.find_all_by_name(v)
end
end

# BINARIES CONSTANTS


end
