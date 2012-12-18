#!/usr/bin/env ruby
#
# adium_proxy_toggle
# Andrew Burnheimer
#
# Look for proxy configurations in an Adium property list (plist) file,
# and enable or disable them.

require 'rubygems'
require 'logging'
require 'trollop'
require 'tempfile'
require 'plist'

APP_NAME = "adium_proxy_toggle"

Logging.logger.root.level = :debug

log = Logging.logger[APP_NAME]
log.add_appenders(Logging.appenders.stderr)
log.level = :info

opts = Trollop::options do
  version "#{APP_NAME} 1.0.0 (c) 2012 Andrew Burnheimer"

  banner <<-EOS
Look for proxy configurations in an Adium property list (plist) file, and enable or disable them.

Usage:
       #{APP_NAME} [options] [plist_filename]

...where the [options] are:
EOS

  opt :verbose, 'Provide detailed output for debugging'
  opt :disable, 'Force any proxy configurations disabled', :short => '-d'
  opt :enable, 'Force any proxy configurations enabled', :short => '-e'
  opt :'show-only', %q|Shew proxy configuration status, but don't | +
      %q|toggle the setting|, :short => '-s'
end

log.level = :debug if opts[:verbose]

log.debug "Set command-line options follow:"
opts.each do |parameter,value|
  log.debug %Q|#{parameter}: #{value.class} (#{value.inspect})|
end

plist_filename = String.new
plist_filename = ARGV.first unless ARGV.first.nil?

if plist_filename.empty?
  plist_filename = File.join(Dir.home(), 'Library',
      'Application Support', 'Adium 2.0', 'Users', 'Default',
      'AccountPrefs.plist')
end
log.debug "plist_filename: #{plist_filename}"

#### DONE OPTION AND ARGUMENT HANDLING ####

temp_file = Tempfile.new("adium_proxy_toggle")
temp_filename = temp_file.path
log.debug "Tempfile opened: #{temp_filename}"

FileUtils.cp plist_filename, temp_filename

`plutil -convert xml1 #{temp_filename}`
log.debug "Tempfile converted to XML"

account_prefs = Plist::parse_xml(temp_filename)

account_keys_with_proxies = Array.new
account_keys_with_proxies = account_prefs.keys.select do |ap|
  !account_prefs[ap]["Proxy Host"].nil? && !account_prefs[ap]["Proxy Host"].empty?
end
log.debug "#{account_keys_with_proxies.count} account key(s) were " +
    "found with proxies configured"

##### Data structures loaded #####
if opts[:'show-only']
  proxies_enabled = false

  if account_keys_with_proxies.empty?
    log.info "No web proxies are configured"
    exit 0
  else
    account_keys_with_proxies.each do |key|
      proxies_enabled = true if account_prefs[key]["Proxy Enabled"] == 1
    end
  end

  if proxies_enabled
    log.info "Web proxies are configured and at least one is enabled"
    exit 0
  else
    log.info "Web proxies are configured, but all are disabled"
    exit 1
  end
else

  unless account_keys_with_proxies.empty?

    set_proxy = false
    if opts[:enable]
      set_proxy = true
    elsif opts[:disable]
      set_proxy = false
    else
      set_proxy = \
        ! (account_prefs[account_keys_with_proxies.first]["Proxy Enabled"] == 1)
    end

    account_keys_with_proxies.each do |key|
      account_prefs[key]["Proxy Enabled"] = set_proxy ? 1 : 0
    end

    log.info "Any configured web proxies have been " +
        ( set_proxy ? "en" : "dis" ) + "abled"

    File.open(temp_filename, 'w') { |f| f << account_prefs.to_plist }
    `plutil -convert binary1 #{temp_filename}`
    log.debug "Tempfile converted to Binary"

    FileUtils.cp temp_filename, plist_filename
  end
end
temp_file.delete
log.debug "Tempfile has been deleted"

exit 0
