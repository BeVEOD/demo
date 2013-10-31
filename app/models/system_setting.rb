# -*- encoding : utf-8 -*-
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
## This has been generated by Faveod Generator on Thu Apr 04 01:36:22 +0200 2013
## It should be placed at 'app/models/system_setting.rb'
## All manual modifications will be destroyed on next generation
################################################


class SystemSetting < ActiveRecord::Base

  self.table_name = 'system_settings'

  SEARCHABLE_FIELDS = [:name].freeze
  RESTRICTED_FIELDS = [].freeze
  FIELDS = HashWithIndifferentAccess.new(:name => :string, :value => :text).freeze
  COMPARATORS = {:name => ActiveSupport::OrderedHash['=~', ["system_settings.name LIKE ?", '%%%s%'], '!~', ["system_settings.name NOT LIKE ?", '%%%s%'], '^=', ["system_settings.name LIKE ?", '%s%'], '$=', ["system_settings.name LIKE ?", '%%%s'], '=', ["system_settings.name = ?"], '!=', ["system_settings.name <> ?"], 'NULL', ["system_settings.name IS NULL", ''], 'NOT_NULL', ["system_settings.name IS NOT NULL", '']],
  :value => ActiveSupport::OrderedHash['=~', ["system_settings.value LIKE ?", '%%%s%'], '!~', ["system_settings.value NOT LIKE ?", '%%%s%'], '^=', ["system_settings.value LIKE ?", '%s%'], '$=', ["system_settings.value LIKE ?", '%%%s'], '=', ["system_settings.value = ?"], '!=', ["system_settings.value <> ?"], 'NULL', ["system_settings.value IS NULL", ''], 'NOT_NULL', ["system_settings.value IS NOT NULL", '']]}.freeze

  FILES_DEST = Rails.root.join('files', %q{system_settings}).to_s


  # == Validations


  validates_presence_of(:name)


  # == Triggers


  after_save(:reset_cached_hash)


  # == Relations
  #
  # Associations through specific setters
  #
  # Virtual Fields
  # == Methods
  #



  # Load the matching object with right attributes.
  #
  # Author:: Sylvain Abélard
  # Version:: 53
  # Last Update:: 2013-03-22 09:46:46 UTC
  # Status:: Validated


  def self.load_from_params(att)
    return SystemSetting.new if att.blank?
    std_atts = att.reject{|k,v| %w(id).include?(k.to_s) }
    system_setting = nil
    if att.has_key?(:id) && att[:id].to_i != 0 # Useful for HasOne (ho_assoc)
      system_setting = SystemSetting.find(att[:id])
      system_setting.attributes = std_atts
    else
      system_setting = SystemSetting.new(std_atts)
    end

    # clean associations
    #clean binaries


    return system_setting
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
    self.name
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
      SystemSetting.new.params_to_attributes(values).each { |k,v|
        case k.to_sym
        when :name
          cmp = comps["comp_name"]
          cmp ||= 'STARTS WITH'
          val = cmp == 'IS NULL' ? nil : (cmp == 'IN' ? v.split(',') : v)
          field = string_h[cmp].nil? ? :name : "name_#{string_h[cmp]}"
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
      country = SystemSetting.find_by_name(pi)
      poly = l.css('Polygon').to_a.flatten.map{|p|
        p.content.gsub(/,0\.0/, ',').split(',').map(&:to_f)
      }.flatten
      (poly.length / 2).times{
        country.systemsetting_borders.create(:lat => poly.shift, :lng => poly.shift)
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

    SystemSetting.first(:order => 'system_settings.id DESC', :conditions => ["system_settings.id < ?", self.id])
  end


  # Returns next element.
  #
  # Author:: Yann Azoury
  # Version:: 1
  # Last Update:: 2010-04-02 13:10:22 UTC
  # Status:: Validated


  def next

    SystemSetting.first(:order => 'system_settings.id', :conditions => ["system_settings.id > ?", self.id])
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
      if [:name, :value
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


# Return Value from cache
#
# Author:: Yann Azoury
# Version:: 2
# Last Update:: 2010-04-03 17:40:22 UTC
# Status:: Validated


def self.[](key)
self.cached_hash[key]
end


# Create a static cache value store.
#
# Author:: Yann Azoury
# Version:: 2
# Last Update:: 2010-04-03 17:42:11 UTC
# Status:: Validated


def self.cached_hash
@@cached_hash ||= SystemSetting.all.inject(HashWithIndifferentAccess.new) {|acc,elt|
  acc.merge!(elt.name => (elt.value == 'false' ? false : elt.value))
}
end


# Resets Cached Hash.
#
# Author:: Yann Azoury
# Version:: 1
# Last Update:: 2010-04-03 17:43:17 UTC
# Status:: Validated


def reset_cached_hash
@@cached_hash = nil
end


# Author:: Sylvain Abélard
# Version:: 3
# Last Update:: 2011-07-04 14:18:31 UTC
# Status:: Validation Pending


def self.true?(key)
val = SystemSetting[key]
return false if !val
return val if val == true || val == false
return ['true', 'vrai', 'yes', 'oui', '1'].include?(val)
end


# Stats about contents of a folder.
#
# Author:: Yann Azoury
# Version:: 2
# Last Update:: 2012-03-16 18:28:42 UTC
# Status:: Validated


def self.contents_folder(folder)
count_subfolder	= 0
count_file	= 0
folder_size	= 0
if (Dir[folder].empty? == false)
  Dir.entries(folder).each{|f|
    if ((f != ".") and (f != ".."))
      f = File.join(folder, f)
      if File.directory?(f)
        tmp = contents_folder(f)
        count_subfolder += 1
        count_subfolder += tmp[0]
        count_file	+= tmp[1]
        folder_size	+= tmp[2]
      else
        count_file	+= 1

        # File.exists? fixes a bug when a tmp file is present
        # (file name like "#.emacs#") which makes File.size crash

        folder_size	+= File.size(f) if File.exists?(f)
      end
    end
  }
end
return count_subfolder, count_file, folder_size
end


# Zip a file.
#
# Author:: Yann Azoury
# Version:: 1
# Last Update:: 2012-03-16 18:40:13 UTC
# Status:: In Progress


def self.zip_file(folder_path, complete_path, zipfile=nil)
if zipfile
  Dir.entries(complete_path).each{|f|
    if (f != ".") && (f != "..")
      folder = File.join(folder_path, f)
      complete = File.join(complete_path, f)
      if (File.directory?(complete))
        zipfile.dir.mkdir(folder)
        zip_file(folder, complete, zipfile)
      else
        zipfile.add(folder, complete)
      end
    end
  }
else
  Zip::ZipFile.open(complete_path + '.zip', true){|zf|
    zip_file(folder_path, complete_path, zf)
  }
end
end


# Author:: Yann Azoury
# Version:: 1
# Last Update:: 2012-03-16 18:47:24 UTC
# Status:: Validated


def self.unzip_file(file, destination)
res = {:success => true}
begin
  Zip::ZipFile.open(file) {|zip_file|
    zip_file.each {|f|
      f_path = File.join(destination, f.name)
      FileUtils.mkdir_p(File.dirname(f_path))
      zip_file.extract(f, f_path) unless File.exist?(f_path)
    }
  }
rescue Exception => e
  res[:success] = false
  res[:error]   = e.message
end
return res
end


# Author:: Sylvain Abélard
# Version:: 1
# Last Update:: 2013-02-07 09:42:50 UTC
# Status:: In Progress


def self.json2hash(s,opts={})

jsn	= s || "{}"
conv	= nil
jsnconv	= nil
res	= nil

# ENCODINGS

begin
  conv = Iconv.new('UTF8//TRANSLIT//IGNORE', 'LATIN1')
  jsnconv  = conv.iconv(jsn)
rescue
  begin
    conv = Iconv.new('UTF8//TRANSLIT//IGNORE', 'UTF8')
    jsnconv  = conv.iconv(jsn)
  rescue
    true
  end
end

# JSON

begin
  res = ActiveSupport::JSON.decode(jsnconv) || {}
rescue
  logger.warn("ERROR: JSON2HASH: CONV:\n===S: #{s.inspect}\n===JSN #{jsn.inspect}\n===JSNCONV: #{jsnconv.inspect}")
  begin
    res = ActiveSupport::JSON.decode(jsn) || {}
  rescue
    logger.warn("ERROR: JSON2HASH: JSON:\n===S: #{s.inspect}\n===JSN #{jsn.inspect}\n===JSNCONV: #{jsnconv.inspect}")
  end
end
res || {}
end

def self.assoc_sids_to_columns(attrs)
h = attrs.has_key?(:conditions) ? attrs[:conditions] : attrs
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


# Importing raw data: string, text, color and any_objects.
#
# Author:: Sylvain Abélard
# Version:: 2
# Last Update:: 2011-06-08 19:24:00 UTC
# Status:: Requires Tests


def value_from_spreadsheet(v, opts={})
v
end


# Exporting: displays raw value
#
# Author:: Sylvain Abélard
# Version:: 4
# Last Update:: 2011-06-09 19:52:49 UTC
# Status:: Validation Pending


def value_to_spreadsheet(opts={})
self.value
end

end
