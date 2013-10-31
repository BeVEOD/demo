require 'open-uri'
require 'hpricot'
require 'timeout'

module Faveod

## SEE http://www.user-agents.org
  USER_AGENTS = ["Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6",
                 "Mozilla/5.0 (compatible; Konqueror/2.2.2; Linux 2.4.14-xfs; X11; i686)",
                 "Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.0.1) Gecko/20021219 Chimera/0.6",
                 "Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.0.1) Gecko/20030306 Camino/0.7",
                 "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-US) AppleWebKit/xx (KHTML like Gecko) OmniWeb/v5xx.xx",
                 "W3CLineMode/5.4.0 libwww/5.x.x",
                 "Lynx/2.8.4rel.1 libwww-FM/2.14 SSL-MM/1.4.1 OpenSSL/0.9.6c",
                 "Links (0.9xpre12; Linux 2.2.14-5.0 i686; 80x24)"]


class GoogleTranslationService
  DEST_FOR_EN = ['ar', 'zh-CN', 'zh-TW', 'fr', 'de', 'it', 'ja', 'ko', 'pt', 'ru', 'es']
  CAPACITIES = {'en' => DEST_FOR_EN}


  def uri_for(text, to, from = 'en')
    @uri ||= URI.parse("http://translate.google.com/translate_t")
    @uri.query = URI.encode("langpair=#{from}|#{to}&text=#{text}")
    return @uri
  end

  def send_request(text, from, to)
    return nil unless CAPACITIES[from] && CAPACITIES[from].include?(to)
    timeout(10) do
      @doc = open(self.uri_for(text, to, from).to_s, {"User-Agent" => USER_AGENTS[rand(USER_AGENTS.size)]}) { |f| #randomize user-agent
        Hpricot(f)
      }
    end
    return @doc
  end

  def get_result_from(doc)
    raise "Google did not answer correctly" if doc.nil?
    return (doc/"#result_box").inner_text
  end

end

class AVBBFTranslationService
  def uri_for(text, to, from = 'en')

  end
end

module PoUtils

  def find_msgids_to_translate(po=nil)
    case po
    when Locale
      return find_msgids_to_translate_file(File.join(RAILS_ROOT, 'po', po.to_s, APP_SID + '.po'))
    when String
      return find_msgids_to_translate_file(po)
    when nil
      AppLocale.app_locales.collect { |po|
        find_msgids_to_translate(File.join(RAILS_ROOT, 'po', po.to_s, APP_SID + '.po'))
      }
    end
  end

  def find_msgids_to_translate_file(po_file)
    ids = []
    IO.popen("msgattrib --no-obsolete --no-fuzzy --untranslated --no-wrap --no-location #{po_file} | grep msgid").readlines.each{ |l|
      pmsgid = l.sub(/^msgid\ "(.*)"\n$/, '\1')
      next if pmsgid.blank?
      pmsgid = pmsgid.split('|').last
      ids << pmsgid
    }
    return ids
  end
end



class TranslationServer
  include Faveod::PoUtils

  SEPARATOR = '[```]'
  DEST_FOR_EN = GoogleTranslationService::DEST_FOR_EN

  attr_accessor :po_file, :dest_lg, :from_lg, :msgids, :options, :translations, :errors, :logger

  def self.translate(text, from, dest, opts = {})

  end

  def initialize(path, destlg, from = 'en', opts = {})
    @logger = opts[:logger] if opts[:logger]
    @po_file = path
    @dest_lg = destlg
    @from_lg = from
#    return nil unless can_translate?
    @options = opts
    @errors = []
  end

  def run(opts = {})
    logger.debug("Running TS for #{po_file} in #{dest_lg}") if logger
    self.find_empty_msgstr
    logger.debug("\t--- TS has fund #{msgids.size} msgids too translate") if logger
    self.get_translations(opts)
    logger.debug("\t--- TS has fetch #{translations.size}") if logger
    self.write_to_file(opts[:dest_file] || po_file)
    logger.debug("\t TS is done for #{dest_lg}") if logger
  end

  def count_of_empty_msgids
    self.find_empty_msgstr
    return msgids.size
  end

  def self.can_translate?(dest, from = 'en')
    return DEST_FOR_EN.include?(dest)
  end

  def can_translate?
    return DEST_FOR_EN.include?(dest_lg)
  end

  def find_empty_msgstr
    @msgids = find_msgids_to_translate(po_file)
  end

  # weird solution for windows...
  def find_empty_msgstr_win
    @msgids = []
    pmsgid = nil
    File.open(po_file, 'r').readlines.each{|l|
      next unless l =~ /^msg/
      if l =~ /^msgid/
        pmsgid = l.sub(/^msgid\ "(.*)"\n$/, '\1')
      elsif l == %{msgstr ""\n}
        @msgids << pmsgid unless pmsgid.blank?
      end
    }
    raise "Nothing to do for #{po_file}" if @msgids.empty?
  end

  def get_translations(opts = {}) # GOOGLE only for now
    opts = options.merge(opts)
    @translations = {}
    service = GoogleTranslationService.new
    if opts[:group] # TODO group by small groups
      mi = msgids.join(SEPARATOR)
      begin
        @doc = service.send_request(mi, 'en', dest_lg)
      rescue
        @errors << {mi => dest_lg}
        logger.warn("Timeout for #{mi}\n\n#{$!}") if logger
      end
      text = service.get_result_from(@doc)
      raise "Google did not answer correctly" if text.blank?
      texts = text.split(" " + SEPARATOR)
      raise "Google can't translate more" if texts.empty?
      if msgids.size == texts.size
        msgids.each_with_index{|id, i| @translations[id] = texts[i]}
      end
    else
      msgids.each_with_index{ |mi,idx|
        break if idx > 10 ## Security to avoid ban
        begin
          @doc = nil
          mi = mi.split('|').last if mi[/\|/]
          @doc = service.send_request(mi, 'en', dest_lg)
        rescue
          @errors << {mi => dest_lg}
          logger.warn("Timeout for #{mi}\n#{$!}") if logger
        end
        text = service.get_result_from(@doc).sub(/\ $/, '')
        raise "Google can't translate more" if text.blank?
        @translations[mi] = text
        logger.debug("GOOGLE translates '#{mi}' *by* '#{text}'     in '#{dest_lg}'") if logger
      }
    end
    return @translations
  end

  def write_to_file(path = po_file)
    return if @translations.empty?
    lines = File.open(po_file, 'r').readlines
    @translations.keys.each{ |k|
      i = lines.index(%{msgid "#{k}"\n})
      if lines[i+1] == %{msgstr ""\n}
#        puts "Replace #{k} at #{i+1} by #{@todo[k]}"
        lines[i+1] = %{msgstr "#{@translations[k]}"\n}
      end
    }
    logger.debug("\t Writing Translations to #{path}") if logger
    File.open(path, 'w'){|f| f.write lines }
  end

end

end
