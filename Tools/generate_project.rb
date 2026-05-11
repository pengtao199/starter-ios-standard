#!/usr/bin/env ruby

require "fileutils"
require "json"
require "pathname"
require "xcodeproj"

root = File.expand_path("..", __dir__)
config_path = File.join(root, ".starter-project.json")
config = JSON.parse(File.read(config_path))

project_name = config.fetch("project_name")
source_dir = config.fetch("source_dir")
target_name = config.fetch("module_name")
bundle_id = config.fetch("bundle_id")
deployment_target = config.fetch("deployment_target")
marketing_version = config.fetch("marketing_version")
current_project_version = config.fetch("current_project_version")

project_path = File.join(root, "#{project_name}.xcodeproj")
app_root = File.join(root, source_dir)

abort "Missing source directory: #{app_root}" unless Dir.exist?(app_root)

FileUtils.rm_rf(project_path)

project = Xcodeproj::Project.new(project_path)
project.root_object.development_region = "en"
project.root_object.known_regions = ["en", "zh-Hans"]
project.root_object.attributes["LastUpgradeCheck"] = "1600"

target = project.new_target(:application, target_name, :ios, deployment_target)

project.root_object.product_ref_group = nil

target.frameworks_build_phase.files.to_a.each do |build_file|
  target.frameworks_build_phase.remove_build_file(build_file)
  build_file.remove_from_project
end

project.main_group.children.to_a.each do |child|
  next unless ["Frameworks", "Products"].include?(child.display_name)

  child.remove_children_recursively
  child.remove_from_project
end

project.build_configurations.each do |config|
  config.build_settings["CLANG_ENABLE_MODULES"] = "YES"
  config.build_settings["SWIFT_VERSION"] = "5.0"
  config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = deployment_target
end

target.build_configurations.each do |config|
  config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = bundle_id
  config.build_settings["MARKETING_VERSION"] = marketing_version
  config.build_settings["CURRENT_PROJECT_VERSION"] = current_project_version
  config.build_settings["SWIFT_VERSION"] = "5.0"
  config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = deployment_target
  config.build_settings["INFOPLIST_FILE"] = "#{source_dir}/Info.plist"
  config.build_settings["GENERATE_INFOPLIST_FILE"] = "NO"
  config.build_settings["CODE_SIGN_STYLE"] = "Automatic"
  config.build_settings["DEVELOPMENT_TEAM"] = ""
  config.build_settings["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS"] = "NO"
  config.build_settings["TARGETED_DEVICE_FAMILY"] = "1,2"
  config.build_settings["SUPPORTS_MACCATALYST"] = "NO"
end

app_group = project.main_group.new_group(source_dir, source_dir)
group_cache = {}

def group_for_relative_dir(root_group, relative_dir, group_cache)
  return root_group if relative_dir == "."

  current_group = root_group
  current_path = []

  relative_dir.split(File::SEPARATOR).each do |segment|
    current_path << segment
    cache_key = current_path.join("/")
    current_group = group_cache[cache_key] ||= current_group.new_group(segment, segment)
  end

  current_group
end

Dir.glob(File.join(app_root, "**/*.swift")).sort.each do |path|
  relative = Pathname(path).relative_path_from(Pathname(app_root)).to_s
  group = group_for_relative_dir(app_group, File.dirname(relative), group_cache)
  reference = group.new_reference(File.basename(relative))
  target.source_build_phase.add_file_reference(reference)
end

localization_group = group_for_relative_dir(app_group, "Resources/Localization", group_cache)

[
  "en.lproj",
  "zh-Hans.lproj"
].each do |relative|
  reference = localization_group.new_reference(relative)
  target.resources_build_phase.add_file_reference(reference)
end

[
  "Info.plist"
].each do |relative|
  app_group.new_reference(relative)
end

project.save
puts "Generated #{project_path}"
