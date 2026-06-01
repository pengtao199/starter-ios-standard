#!/usr/bin/env ruby

require "fileutils"
require "json"
require "optparse"
require "xcodeproj"

ROOT = File.expand_path("..", __dir__)
CONFIG_PATH = File.join(ROOT, ".starter-project.json")

DEFAULT_CONFIG = {
  "owner" => "",
  "product_name" => "Starter App",
  "module_name" => "StarterApp",
  "app_struct_name" => "StarterApp",
  "project_name" => "StarterApp",
  "source_dir" => "StarterApp",
  "bundle_id" => "co.example.starterapp",
  "marketing_version" => "1.0",
  "current_project_version" => "1",
  "deployment_target" => "17.0",
  "network_base_url" => "https://api.example.com",
  "app_store_id" => "0000000000",
  "share_url" => "https://example.com/app",
  "support_email" => "support@example.com",
  "terms_url" => "https://example.com/legal/terms",
  "privacy_url" => "https://example.com/legal/privacy"
}.freeze

options = {}

parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby Tools/reset_project.rb --owner NAME --product-name NAME --bundle-id ID [options]"

  opts.on("--owner NAME", "Owner or team name") { |value| options[:owner] = value }
  opts.on("--product-name NAME", "Display product name, for example \"Focus Notes\"") { |value| options[:product_name] = value }
  opts.on("--bundle-id ID", "Bundle identifier, for example com.example.focusnotes") { |value| options[:bundle_id] = value }
  opts.on("--module-name NAME", "Swift module, target, source folder, and xcodeproj name") { |value| options[:module_name] = value }
  opts.on("--marketing-version VERSION", "Marketing version, default keeps current value") { |value| options[:marketing_version] = value }
  opts.on("--build-number NUMBER", "Build number, default keeps current value") { |value| options[:current_project_version] = value }
  opts.on("--api-base-url URL", "Network base URL, default keeps current value") { |value| options[:network_base_url] = value }
  opts.on("--app-store-id ID", "App Store ID, default keeps current value") { |value| options[:app_store_id] = value }
  opts.on("--share-url URL", "Share URL, default keeps current value") { |value| options[:share_url] = value }
  opts.on("--support-email EMAIL", "Support email, default keeps current value") { |value| options[:support_email] = value }
  opts.on("--terms-url URL", "Terms URL, default keeps current value") { |value| options[:terms_url] = value }
  opts.on("--privacy-url URL", "Privacy URL, default keeps current value") { |value| options[:privacy_url] = value }
end

parser.parse!

def abort_with_usage(parser, message)
  warn "Error: #{message}"
  warn
  warn parser
  exit 1
end

def pascalize(value)
  value.to_s
       .gsub(/[^A-Za-z0-9]+/, " ")
       .split
       .map { |token| token[0].upcase + token[1..] }
       .join
end

def escaped_source_string(value)
  value.to_s.gsub("\\", "\\\\\\").gsub("\"", "\\\"")
end

def escaped_plist_string(value)
  value.to_s
       .gsub("&", "&amp;")
       .gsub("<", "&lt;")
       .gsub(">", "&gt;")
end

def validate_swift_identifier!(value)
  return if value.match?(/\A[A-Za-z_][A-Za-z0-9_]*\z/)

  raise ArgumentError, "module name must be a valid Swift identifier: #{value}"
end

def validate_bundle_id!(value)
  return if value.match?(/\A[A-Za-z0-9][A-Za-z0-9-]*(\.[A-Za-z0-9][A-Za-z0-9-]*)+\z/)

  raise ArgumentError, "bundle id must look like reverse DNS, for example com.example.app"
end

def read_config
  return DEFAULT_CONFIG.dup unless File.exist?(CONFIG_PATH)

  DEFAULT_CONFIG.merge(JSON.parse(File.read(CONFIG_PATH)))
end

def write_config(config)
  File.write(CONFIG_PATH, "#{JSON.pretty_generate(config)}\n")
end

def rewrite_file(path)
  original = File.read(path)
  updated = yield original
  File.write(path, updated) if updated != original
end

def replace_swift_string_assignment(content, label, value)
  escaped = Regexp.escape(label)
  content.sub(/#{escaped}:\s*"[^"]*"/) do
    "#{label}: \"#{escaped_source_string(value)}\""
  end
end

def replace_url_assignment(content, label, value)
  escaped = Regexp.escape(label)
  content.sub(/#{escaped}:\s*URL\(string:\s*"[^"]*"\)!/) do
    "#{label}: URL(string: \"#{escaped_source_string(value)}\")!"
  end
end

def replace_plist_value(content, key, value)
  escaped = Regexp.escape(key)
  content.sub(/(<key>#{escaped}<\/key>\s*<string>)[^<]*(<\/string>)/m) do
    "#{$1}#{escaped_plist_string(value)}#{$2}"
  end
end

def replace_strings_value(content, key, value)
  escaped = Regexp.escape(key)
  content.sub(/"#{escaped}"\s*=\s*"[^"]*";/) do
    "\"#{key}\" = \"#{escaped_source_string(value)}\";"
  end
end

def rewrite_text_files(paths, replacements)
  paths.each do |path|
    rewrite_file(path) do |content|
      replacements.reduce(content) do |result, (old_value, new_value)|
        next result if old_value.to_s.empty? || old_value == new_value

        result.gsub(old_value, new_value)
      end
    end
  end
end

owner = options[:owner].to_s.strip
product_name = options[:product_name].to_s.strip
bundle_id = options[:bundle_id].to_s.strip

abort_with_usage(parser, "--owner is required") if owner.empty?
abort_with_usage(parser, "--product-name is required") if product_name.empty?
abort_with_usage(parser, "--bundle-id is required") if bundle_id.empty?

begin
  validate_bundle_id!(bundle_id)
rescue ArgumentError => error
  abort_with_usage(parser, error.message)
end

module_name = options[:module_name].to_s.strip
module_name = pascalize(product_name) if module_name.empty?
module_name = pascalize(bundle_id.split(".").last) if module_name.empty?
module_name = "App#{module_name}" unless module_name.match?(/\A[A-Za-z_]/)

begin
  validate_swift_identifier!(module_name)
rescue ArgumentError => error
  abort_with_usage(parser, error.message)
end

current_config = read_config
old_product_name = current_config.fetch("product_name")
old_module_name = current_config.fetch("module_name")
old_app_struct_name = current_config.fetch("app_struct_name")
old_source_dir = current_config.fetch("source_dir")
old_bundle_id = current_config.fetch("bundle_id")
old_subscription_title = old_product_name == "Starter App" ? "Starter Pro" : "#{old_product_name} Pro"

app_struct_name = module_name
source_dir = module_name
subscription_title = "#{product_name} Pro"

new_config = current_config.merge(
  "owner" => owner,
  "product_name" => product_name,
  "module_name" => module_name,
  "app_struct_name" => app_struct_name,
  "project_name" => module_name,
  "source_dir" => source_dir,
  "bundle_id" => bundle_id,
  "marketing_version" => options[:marketing_version] || current_config.fetch("marketing_version"),
  "current_project_version" => options[:current_project_version] || current_config.fetch("current_project_version"),
  "network_base_url" => options[:network_base_url] || current_config.fetch("network_base_url"),
  "app_store_id" => options[:app_store_id] || current_config.fetch("app_store_id"),
  "share_url" => options[:share_url] || current_config.fetch("share_url"),
  "support_email" => options[:support_email] || current_config.fetch("support_email"),
  "terms_url" => options[:terms_url] || current_config.fetch("terms_url"),
  "privacy_url" => options[:privacy_url] || current_config.fetch("privacy_url")
)

old_source_path = File.join(ROOT, old_source_dir)
new_source_path = File.join(ROOT, source_dir)

if old_source_path != new_source_path
  if Dir.exist?(old_source_path)
    abort "Source directory already exists: #{new_source_path}" if Dir.exist?(new_source_path)

    FileUtils.mv(old_source_path, new_source_path)
  elsif !Dir.exist?(new_source_path)
    abort "Missing source directory: #{old_source_path}"
  end
end

app_dir = File.join(new_source_path, "App")
old_app_file_candidates = [
  File.join(app_dir, "#{old_app_struct_name}.swift"),
  File.join(app_dir, "#{old_module_name}.swift"),
  File.join(app_dir, "StarterApp.swift")
]
old_app_file = old_app_file_candidates.find { |path| File.exist?(path) }
new_app_file = File.join(app_dir, "#{app_struct_name}.swift")

if old_app_file && old_app_file != new_app_file
  abort "App entry file already exists: #{new_app_file}" if File.exist?(new_app_file)

  FileUtils.mv(old_app_file, new_app_file)
end

project_path = File.join(ROOT, "#{module_name}.xcodeproj")
old_project_path = File.join(ROOT, "#{old_module_name}.xcodeproj")

if old_module_name != module_name && Dir.exist?(old_project_path) && !Dir.exist?(project_path)
  FileUtils.mv(old_project_path, project_path)
end

abort "Missing Xcode project: #{project_path}" unless Dir.exist?(project_path)

app_config_path = File.join(new_source_path, "Config", "AppConfig.swift")
rewrite_file(app_config_path) do |content|
  content = replace_swift_string_assignment(content, "displayName", product_name)
  content = replace_swift_string_assignment(content, "bundleIdentifier", bundle_id)
  content = replace_swift_string_assignment(content, "version", new_config.fetch("marketing_version"))
  content = replace_swift_string_assignment(content, "buildNumber", new_config.fetch("current_project_version"))
  replace_url_assignment(content, "networkBaseURL", new_config.fetch("network_base_url"))
end

support_config_path = File.join(new_source_path, "Config", "SupportConfig.swift")
rewrite_file(support_config_path) do |content|
  content = replace_swift_string_assignment(content, "appStoreID", new_config.fetch("app_store_id"))
  content = replace_url_assignment(content, "shareURL", new_config.fetch("share_url"))
  replace_swift_string_assignment(content, "supportEmail", new_config.fetch("support_email"))
end

legal_config_path = File.join(new_source_path, "Config", "LegalConfig.swift")
rewrite_file(legal_config_path) do |content|
  content = replace_url_assignment(content, "termsOfServiceURL", new_config.fetch("terms_url"))
  replace_url_assignment(content, "privacyPolicyURL", new_config.fetch("privacy_url"))
end

subscription_config_path = File.join(new_source_path, "Config", "SubscriptionConfig.swift")
rewrite_file(subscription_config_path) do |content|
  content = replace_swift_string_assignment(content, "title", subscription_title)
  content = content.sub(/productIDs:\s*\[[^\]]*\]/m, <<~SWIFT.strip)
    productIDs: [
                    "#{bundle_id}.pro.yearly",
                    "#{bundle_id}.pro.monthly"
                ]
  SWIFT
  replace_swift_string_assignment(content, "defaultProductID", "#{bundle_id}.pro.yearly")
end

plist_path = File.join(new_source_path, "Info.plist")
rewrite_file(plist_path) do |content|
  content = replace_plist_value(content, "CFBundleDisplayName", product_name)
  replace_plist_value(content, "CFBundleName", module_name)
end

info_strings_paths = Dir.glob(File.join(new_source_path, "Resources", "Localization", "*.lproj", "InfoPlist.strings"))
info_strings_paths.each do |path|
  rewrite_file(path) do |content|
    replace_strings_value(content, "CFBundleDisplayName", product_name)
  end
end

localizable_paths = Dir.glob(File.join(new_source_path, "Resources", "Localization", "*.lproj", "Localizable.strings"))
localizable_paths.each do |path|
  simplified_chinese = path.include?("zh-Hans.lproj")
  feedback_subject = simplified_chinese ? "#{product_name} 反馈" : "#{product_name} Feedback"
  subscription_subtitle = if simplified_chinese
                            "#{subscription_title} 已准备好支撑你的下一个 App。"
                          else
                            "#{subscription_title} is ready to power your next app."
                          end

  rewrite_file(path) do |content|
    content = replace_strings_value(content, "settings.feedback.subject", feedback_subject)
    content = replace_strings_value(content, "settings.subscription", subscription_title)
    content = replace_strings_value(content, "subscription.title", subscription_title)
    replace_strings_value(content, "subscription.subtitle.default", subscription_subtitle)
  end
end

source_text_files = Dir.glob(File.join(new_source_path, "**", "*.{swift,plist,strings,xcprivacy}"))
rewrite_text_files(
  source_text_files,
  {
    old_app_struct_name => app_struct_name,
    old_module_name => module_name,
    old_product_name => product_name,
    old_subscription_title => subscription_title,
    old_bundle_id => bundle_id,
    "#{old_bundle_id}.preferences" => "#{bundle_id}.preferences",
    "#{old_bundle_id}.subscription" => "#{bundle_id}.subscription",
    "starter.preferences" => "#{bundle_id}.preferences",
    "starter.subscription" => "#{bundle_id}.subscription"
  }
)

docs_text_files = Dir.glob(File.join(ROOT, "{README.md,AGENTS.md,Docs/**/*.md,Plans/**/*.md,Rules/**/*.md,Templates/**/*.md}"))
rewrite_text_files(
  docs_text_files,
  {
    "#{old_module_name}.xcodeproj" => "#{module_name}.xcodeproj",
    "#{old_source_dir}/" => "#{source_dir}/",
    old_source_dir => source_dir,
    old_module_name => module_name,
    old_product_name => product_name
  }
)

write_config(new_config)

# Update Xcode project with new configuration
project = Xcodeproj::Project.open(project_path)
target = project.targets.first

unless target
  abort "No targets found in #{project_path}"
end

# Update target name
if target.name != module_name
  target.name = module_name
  target.display_name = module_name
end

# Update build configurations
target.build_configurations.each do |config|
  config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = bundle_id
  config.build_settings["PRODUCT_MODULE_NAME"] = module_name
  config.build_settings["MARKETING_VERSION"] = new_config.fetch("marketing_version")
  config.build_settings["CURRENT_PROJECT_VERSION"] = new_config.fetch("current_project_version")
end

# Update display name in Info.plist settings
target.build_configurations.each do |config|
  config.build_settings["INFOPLIST_FILE"] = "#{source_dir}/Info.plist"
end

project.save

puts
puts "Reset complete"
puts "Owner: #{owner}"
puts "Product: #{product_name}"
puts "Bundle ID: #{bundle_id}"
puts "Project: #{module_name}.xcodeproj"
