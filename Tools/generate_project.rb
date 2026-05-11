#!/usr/bin/env ruby

require "fileutils"
require "pathname"
require "xcodeproj"

root = File.expand_path("..", __dir__)
project_path = File.join(root, "StarterApp.xcodeproj")
app_root = File.join(root, "StarterApp")

FileUtils.rm_rf(project_path)

project = Xcodeproj::Project.new(project_path)
project.root_object.development_region = "en"
project.root_object.known_regions = ["en", "zh-Hans"]
project.root_object.attributes["LastUpgradeCheck"] = "1600"

target = project.new_target(:application, "StarterApp", :ios, "18.0")

project.build_configurations.each do |config|
  config.build_settings["CLANG_ENABLE_MODULES"] = "YES"
  config.build_settings["SWIFT_VERSION"] = "5.0"
  config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "18.0"
end

target.build_configurations.each do |config|
  config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = "co.example.starterapp"
  config.build_settings["MARKETING_VERSION"] = "1.0"
  config.build_settings["CURRENT_PROJECT_VERSION"] = "1"
  config.build_settings["SWIFT_VERSION"] = "5.0"
  config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "18.0"
  config.build_settings["INFOPLIST_FILE"] = "StarterApp/Info.plist"
  config.build_settings["GENERATE_INFOPLIST_FILE"] = "NO"
  config.build_settings["CODE_SIGN_STYLE"] = "Automatic"
  config.build_settings["DEVELOPMENT_TEAM"] = ""
  config.build_settings["ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS"] = "NO"
  config.build_settings["TARGETED_DEVICE_FAMILY"] = "1,2"
  config.build_settings["SUPPORTS_MACCATALYST"] = "NO"
end

app_group = project.main_group.new_group("StarterApp", "StarterApp")
rules_group = project.main_group.new_group("Rules", "Rules")
docs_group = project.main_group.new_group("Docs", "Docs")
templates_group = project.main_group.new_group("Templates", "Templates")
skill_group = project.main_group.new_group("SkillSpec", "SkillSpec")
tools_group = project.main_group.new_group("Tools", "Tools")

Dir.glob(File.join(app_root, "**/*.swift")).sort.each do |path|
  relative = Pathname(path).relative_path_from(Pathname(app_root)).to_s
  reference = app_group.new_reference(relative)
  target.source_build_phase.add_file_reference(reference)
end

[
  "Resources/Localization/en.lproj",
  "Resources/Localization/zh-Hans.lproj"
].each do |relative|
  reference = app_group.new_reference(relative)
  target.resources_build_phase.add_file_reference(reference)
end

[
  "Info.plist"
].each do |relative|
  app_group.new_reference(relative)
end

Dir.glob(File.join(root, "Rules/**/*.md")).sort.each do |path|
  relative = Pathname(path).relative_path_from(Pathname(root)).to_s
  rules_group.new_reference(relative.sub(%r{\ARules/}, ""))
end

Dir.glob(File.join(root, "Docs/**/*.md")).sort.each do |path|
  relative = Pathname(path).relative_path_from(Pathname(root)).to_s
  docs_group.new_reference(relative.sub(%r{\ADocs/}, ""))
end

Dir.glob(File.join(root, "Templates/**/*.md")).sort.each do |path|
  relative = Pathname(path).relative_path_from(Pathname(root)).to_s
  templates_group.new_reference(relative.sub(%r{\ATemplates/}, ""))
end

Dir.glob(File.join(root, "SkillSpec/**/*.md")).sort.each do |path|
  relative = Pathname(path).relative_path_from(Pathname(root)).to_s
  skill_group.new_reference(relative.sub(%r{\ASkillSpec/}, ""))
end

tools_group.new_reference("generate_project.rb")

project.save
puts "Generated #{project_path}"
