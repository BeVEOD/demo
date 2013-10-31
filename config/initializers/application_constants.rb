STATIC_SETTINGS_PATH = File.join(File.dirname(__FILE__), '..', 'static_settings.yml')
GSS = HashWithIndifferentAccess.new(File.exists?(STATIC_SETTINGS_PATH) ? YAML.load(File.open(STATIC_SETTINGS_PATH, 'r')) : {})
APP_SID = GSS[:app_sid] || 'application' unless defined?('APP_SID')
APP_VERSION = GSS[:app_version] || '1.0.0'
LOCALES_REGEXP = Regexp.new((GSS[:locales] || 'en fr de').split(' ').join('|'))
