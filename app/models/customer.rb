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
## It should be placed at 'app/models/customer.rb'
## All manual modifications will be destroyed on next generation
################################################


class Customer < ActiveRecord::Base

  self.table_name = 'customers'

  SEARCHABLE_FIELDS = [:first_name,:last_name,:user,:new_date,:new_string].freeze
  RESTRICTED_FIELDS = [].freeze
  FIELDS = HashWithIndifferentAccess.new(:first_name => :string, :last_name => :string, :photo => :binary, :user => :bt_assoc, :new_date => :date, :new_string => :string).freeze
  COMPARATORS = {:first_name => ActiveSupport::OrderedHash['=~', ["customers.first_name LIKE ?", '%%%s%'], '!~', ["customers.first_name NOT LIKE ?", '%%%s%'], '^=', ["customers.first_name LIKE ?", '%s%'], '$=', ["customers.first_name LIKE ?", '%%%s'], '=', ["customers.first_name = ?"], '!=', ["customers.first_name <> ?"], 'NULL', ["customers.first_name IS NULL", ''], 'NOT_NULL', ["customers.first_name IS NOT NULL", '']],
    :last_name => ActiveSupport::OrderedHash['=~', ["customers.last_name LIKE ?", '%%%s%'], '!~', ["customers.last_name NOT LIKE ?", '%%%s%'], '^=', ["customers.last_name LIKE ?", '%s%'], '$=', ["customers.last_name LIKE ?", '%%%s'], '=', ["customers.last_name = ?"], '!=', ["customers.last_name <> ?"], 'NULL', ["customers.last_name IS NULL", ''], 'NOT_NULL', ["customers.last_name IS NOT NULL", '']],
    :photo => ActiveSupport::OrderedHash['=~', ["customers.photo__name LIKE ?", '%%%s%'], '!~', ["customers.photo__name NOT LIKE ?", '%%%s%'], '^=', ["customers.photo__name LIKE ?", '%s%'], '$=', ["customers.photo__name LIKE ?", '%%%s'], '=', ["customers.photo__name = ?"], '!=', ["customers.photo__name <> ?"], 'NULL', ["customers.photo__name IS NULL", ''], 'NOT_NULL', ["customers.photo__name IS NOT NULL", '']],
    :user => ActiveSupport::OrderedHash['=', ["customers.user_id = ?"], '!=', ["customers.user_id <> ?"], 'NULL', ["customers.user_id IS NULL", ''], 'NOT_NULL', ["customers.user_id IS NOT NULL", '']],
    :user_id => ActiveSupport::OrderedHash['=', ["customers.user_id = ?"], '!=', ["customers.user_id <> ?"], 'NULL', ["customers.user_id IS NULL", ''], 'NOT_NULL', ["customers.user_id IS NOT NULL", '']],
    :new_date => ActiveSupport::OrderedHash['=', ["customers.new_date = ?"], '!=', ["customers.new_date <> ?"], '>', ["customers.new_date > ?"], '<', ["customers.new_date < ?"], '>=', ["customers.new_date >= ?"], '<=', ["customers.new_date <= ?"]],
    :new_date_min => ActiveSupport::OrderedHash['>=', ["customers.new_date >= ?"], '>', ["customers.new_date > ?"]],
    :new_date_max => ActiveSupport::OrderedHash['<=', ["customers.new_date <= ?"], '<', ["customers.new_date < ?"]],
  :new_string => ActiveSupport::OrderedHash['=~', ["customers.new_string LIKE ?", '%%%s%'], '!~', ["customers.new_string NOT LIKE ?", '%%%s%'], '^=', ["customers.new_string LIKE ?", '%s%'], '$=', ["customers.new_string LIKE ?", '%%%s'], '=', ["customers.new_string = ?"], '!=', ["customers.new_string <> ?"], 'NULL', ["customers.new_string IS NULL", ''], 'NOT_NULL', ["customers.new_string IS NOT NULL", '']]}.freeze

  FILES_DEST = Rails.root.join('files', %q{customers}).to_s


  # == Validations


  validates_presence_of(:last_name)
  validates_uniqueness_of(:last_name)


  # == Triggers


  after_create :photo__after_create_trigger

  after_update :photo__after_update_trigger

  after_destroy :photo__after_destroy_trigger

  # == Relations
  #


  belongs_to :user, :foreign_key => "user_id", :class_name => "User"


  # Associations through specific setters
  #
  # Virtual Fields

  attr_accessor :user_was


  # == Methods
  #



  # Load the matching object with right attributes.
  #
  # Author:: Sylvain Abélard
  # Version:: 53
  # Last Update:: 2013-09-03 16:56:08 UTC
  # Status:: Validated


  def self.load_from_params(att)
    return Customer.new if att.blank?
    std_atts = att.reject{|k,v| %w(id user photo photo_tmp photo_name).include?(k.to_s) }
    customer = nil
    if att.has_key?(:id) && att[:id].to_i != 0 # Useful for HasOne (ho_assoc)
      customer = Customer.find(att[:id])
      customer.attributes = std_atts
    else
      customer = Customer.new(std_atts)
    end

    # clean associations

    customer.user_load_from_params(att[:user])

    #clean binaries

    customer.photo_load_from_params(att)

    #clean serialized data

    return customer
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
    self.last_name || ''
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
      Customer.new.params_to_attributes(values).each { |k,v|
        case k.to_sym
        when :first_name
          cmp = comps["comp_first_name"]
          cmp ||= 'STARTS WITH'
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',') : v)
          field = string_h[cmp].nil? ? :first_name : "first_name_#{string_h[cmp]}"
          cond[field] = val
        when :last_name
          cmp = comps["comp_last_name"]
          cmp ||= 'STARTS WITH'
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',') : v)
          field = string_h[cmp].nil? ? :last_name : "last_name_#{string_h[cmp]}"
          cond[field] = val
        when :user_id
          cmp = comps["comp_user_id"]
          cmp ||= 'IN'
          vals  = val.is_a?(Enumerable) ? v : v.split(',').map(&:to_i)
          val   = cmp == 'IS NULL' ? nil : vals
          field = numb_h[cmp].nil? ? :user_id : "user_id_#{numb_h[cmp]}"
          cond[field] = val
        when :new_date
          cmp = comps["comp_new_date"]
          cmp ||= '='
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',') : v)
          field = date_h[cmp].nil? ? :new_date : "new_date_#{date_h[cmp]}"
          cond[field] = val
        when :new_string
          cmp = comps["comp_new_string"]
          cmp ||= 'STARTS WITH'
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',') : v)
          field = string_h[cmp].nil? ? :new_string : "new_string_#{string_h[cmp]}"
          cond[field] = val
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


  # Creates the thumbnail and returns it.
  #
  # Author:: Yann Azoury
  # Version:: 8
  # Last Update:: 2013-09-03 16:56:08 UTC
  # Status:: Validated


  def thumbnail(sid, opts={})

    maxwidth	= (opts[:maxwidth] || 128).to_f
    maxheight	= (opts[:maxheight] || 128).to_f
    aspectratio	= maxwidth / maxheight
    path		= nil
    dest_path	= nil
    pic		= nil
    case sid.to_sym
    when :photo
      path		= self.photo__path
      dest_path	= self.photo__thumb_path
    end
    pic	   = path ? Magick::Image.read(path).first : Magick::Image.from_blob(pic).first
    imgwidth  = pic.columns
    imgheight = pic.rows
    imgratio  = imgwidth.to_f / imgheight.to_f
    scaleratio= imgratio > aspectratio ? maxwidth / imgwidth : maxheight / imgheight
    thumb	   = pic.thumbnail(scaleratio)
    thumb.write(dest_path) if dest_path
    return thumb.to_blob
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
      country = Customer.find_by_name(pi)
      poly = l.css('Polygon').to_a.flatten.map{|p|
        p.content.gsub(/,0\.0/, ',').split(',').map(&:to_f)
      }.flatten
      (poly.length / 2).times{
        country.customer_borders.create(:lat => poly.shift, :lng => poly.shift)
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

    Customer.first(:order => 'customers.id DESC', :conditions => ["customers.id < ?", self.id])
  end


  # Returns next element.
  #
  # Author:: Yann Azoury
  # Version:: 1
  # Last Update:: 2010-04-02 13:10:22 UTC
  # Status:: Validated


  def next

    Customer.first(:order => 'customers.id', :conditions => ["customers.id > ?", self.id])
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
      if [:first_name, :last_name, :photo, :user, :user_id, :new_date, :new_string
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



# Author:: Pierre Carrio
# Version:: 2
# Last Update:: 2012-11-29 17:07:41 UTC
# Status:: Validated


def photo

if @photo_cache && @photo_cache[:tmp]
  @photo_cache[:path] = File.join(FILES_DEST_PHOTO, 'cache', @photo_cache[:tmp])
end
if @photo_cache && File.exists?(@photo_cache[:path])
  return File.read(@photo_cache[:path])
else
  File.open(self.photo__path, 'r').read unless self.new_record? || !File.exist?(self.photo__path)
end
end


# Gives the file path.
#
# Author:: Pierre Carrio
# Version:: 3
# Last Update:: 2012-11-29 17:08:18 UTC
# Status:: Validated


def photo__path
if !@photo_cache.blank? && !@photo_cache[:path].blank?
  @photo_cache[:path]
else
  File.join(FILES_DEST_PHOTO, "#{self.id}_#{self.photo__name}")
end
end


# Gives the file size.
#
# Author:: Yann Azoury
# Version:: 3
# Last Update:: 2012-01-16 14:40:38 UTC
# Status:: Validated


def photo__size
if File.exist?(self.photo__path)
  return File.size(self.photo__path)
else
  return self.photo ? self.photo.length : 0
end
end


# Sets everything up when saving a file field.
#
# Author:: Yann Azoury
# Version:: 9
# Last Update:: 2013-07-17 02:09:04 UTC
# Status:: Validated


def photo=(val)

# make cache dir

cdir = File.join(FILES_DEST_PHOTO, 'cache')
FileUtils.makedirs(cdir) unless File.exist?(cdir)

# remove existing cache file (create) or file (update)

File.delete(@photo_cache[:path]) if @photo_cache && @photo_cache[:path] && File.exist?(@photo_cache[:path])
File.delete(self.photo__path) if File.exist?(self.photo__path)

#set cache, prepare for failed validation or after_create trigger

@photo_cache ||= {}
@photo_cache[:name] = self.attributes['photo__name']
@photo_cache[:tmp] = "#{UUID.new.generate}--#{@photo_cache[:name]}"
@photo_cache[:path] = File.join(cdir, @photo_cache[:tmp])
File.open(@photo_cache[:path], 'wb') {|f| f.write(val) }

#TODO

return val
end


# Returns thumbnails path for the current data.
#
# Author:: Yann Azoury
# Version:: 1
# Last Update:: 2010-01-18 00:31:32 UTC
# Status:: Validated


def photo__thumb_path

File.join(FILES_DEST_PHOTO__THUMBS, File.basename(self.photo__path))
end


# Returns the MIME Type of current file (based on its name).
#
# Author:: Yann Azoury
# Version:: 1
# Last Update:: 2010-01-18 00:43:35 UTC
# Status:: Validated


def photo__mime_type
if !self.photo__name.blank?
  mt = MIME::Types.of(File.extname(self.photo__name)).first
  return mt ? mt.content_type : "application/octet-stream"
end
end


# Rename the file correctly on the file system after create.
#
# Author:: Pierre Carrio
# Version:: 4
# Last Update:: 2012-12-03 09:41:10 UTC
# Status:: Validated


def photo__after_create_trigger

if !@photo_cache.blank? && !@photo_cache[:tmp].blank?
  @photo_cache[:path] = File.join(FILES_DEST_PHOTO, 'cache', @photo_cache[:tmp])
end
if !@photo_cache.blank? && @photo_cache[:path]
  if File.exist?(@photo_cache[:path])
    File.rename(@photo_cache[:path], File.join(FILES_DEST_PHOTO, "#{self.id}_#{self.photo__name}"))
  else
    logger.warn("Should not happen! cache: #{@photo_cache.inspect} - name: #{self.photo__name}")
  end
end
@photo_cache = {}
end


# Rename Files correctly after update.
#
# Author:: Pierre Carrio
# Version:: 5
# Last Update:: 2012-12-03 09:40:46 UTC
# Status:: Validated


def photo__after_update_trigger

Dir[File.join(FILES_DEST_PHOTO__THUMBS, "#{self.id}_*")].each{|f| File.delete(f); break} #will be regenerated
if !@photo_cache.blank? && !@photo_cache[:tmp].blank?
  @photo_cache[:path] = File.join(FILES_DEST_PHOTO, 'cache', @photo_cache[:tmp])
end
if !@photo_cache.blank? && @photo_cache[:path] && File.exist?(@photo_cache[:path])
  Dir[File.join(FILES_DEST_PHOTO, "#{self.id}_*")].each{|f| File.delete(f); break}
  dest = File.join(FILES_DEST_PHOTO, "#{self.id}_#{self.photo__name}")
  logger.debug("=== CACHE [#{@photo_cache[:path].inspect}] DEST [#{dest.inspect}]")
  FileUtils.mv(@photo_cache[:path], File.join(FILES_DEST_PHOTO, "#{self.id}_#{self.photo__name}"))
else
  src = self.photo__path
  if !File.exists?(src) # bad name
    Dir[File.join(FILES_DEST_PHOTO, "#{self.id}_*")].each{|f| File.rename(f, src); break}
  end
end
@photo_cache = {}
end


# Remove files of destroyed row.
#
# Author:: Yann Azoury
# Version:: 1
# Last Update:: 2010-01-18 01:12:31 UTC
# Status:: Validated


def photo__after_destroy_trigger

Dir[File.join(FILES_DEST_PHOTO, "#{self.id}_*")].each{|f| File.delete(f)}
Dir[File.join(FILES_DEST_PHOTO__THUMBS, "#{self.id}_*")].each{|f| File.delete(f)}
end


# return current cache hash
#
# Author:: Yann Azoury
# Version:: 6
# Last Update:: 2012-11-30 10:43:55 UTC
# Status:: Validated


def photo__cache
@photo_cache ||= {}
end


# Load binary from params.
#
# Author:: Yann Azoury
# Version:: 1
# Last Update:: 2013-07-17 15:50:35 UTC
# Status:: Validated


def photo_load_from_params(att)

val = att[:photo]
if val
  if val == '_destroy'
    self.photo__name = nil
    self.photo = nil
  elsif val == '_forget'
  elsif val.size == 0
    att.delete(:photo)
  else
    self.photo__name = File.basename(val.original_filename).parameterize.sub(/(-)(\w+)\Z/, '.\2')
    self.photo = val.read
  end
else
  if !att[:photo_tmp].blank? && !att[:photo_name].blank?
    self.photo__name         = att[:photo_name]
    self.photo__cache[:name] = att[:photo_name]
    self.photo__cache[:tmp]  = att[:photo_tmp]
  end
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
# Author:: Yann Azoury
# Version:: 4
# Last Update:: 2013-10-02 15:11:56 UTC
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
        nil
      else
        elt
      end
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



def self.photo_folder

Rails.root.join(*('files/photo').split('/'))

end

FILES_DEST_PHOTO = self.photo_folder
FILES_DEST_PHOTO__THUMBS = FILES_DEST_PHOTO + '__thumbs'

FileUtils.makedirs(FILES_DEST_PHOTO) unless File.exist?(FILES_DEST_PHOTO)
FileUtils.makedirs(FILES_DEST_PHOTO__THUMBS) unless File.exist?(FILES_DEST_PHOTO__THUMBS)

after_create {|rec|
src = File.join(FILES_DEST_PHOTO, "_#{rec.photo__name}")
src = File.join(FILES_DEST_PHOTO, "_") unless File.exists?(src)
File.rename(src, File.join(FILES_DEST_PHOTO, "#{rec.id}_#{rec.photo__name}")) if File.exists?(src)

}
after_update {|rec|
src = rec.photo__path
Dir[File.join(FILES_DEST_PHOTO__THUMBS, "#{rec.id}_*")].each{|f| File.delete(f); break}
if !File.exists?(src) # bad name
  Dir[File.join(FILES_DEST_PHOTO, "#{rec.id}_*")].each{|f| File.rename(f, src); break}

end
}
after_destroy {|rec|
Dir[File.join(FILES_DEST_PHOTO, "#{rec.id}_*")].each{|f| File.delete(f)}
Dir[File.join(FILES_DEST_PHOTO__THUMBS, "#{rec.id}_*")].each{|f| File.delete(f)}

}

end
