#!/usr/bin/env ruby

# DEPRECATED: This script is no longer used for development.
# The Xcode project (.xcodeproj) is now committed as a real project file.
# 
# This script is only kept for reference or if you need to completely
# regenerate the project structure. For normal development:
# 
#   open StarterApp.xcodeproj
#
# For resetting to a new project with new bundle ID and app name:
#
#   ruby Tools/reset_project.rb --owner "Name" --product-name "App" --bundle-id "com.example.app"

puts "❌ DEPRECATED: generate_project.rb is no longer used."
puts ""
puts "For development, use:"
puts "  open StarterApp.xcodeproj"
puts ""
puts "For project reset, use:"
puts "  ruby Tools/reset_project.rb --owner NAME --product-name PRODUCT --bundle-id ID"
exit 1
