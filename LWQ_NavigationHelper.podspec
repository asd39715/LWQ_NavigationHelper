
Pod::Spec.new do |s|

  s.name         = "LWQ_NavigationHelper"
  s.version      = "0.0.1"
  s.summary      = "A short description of LWQ_NavigationHelper."

  s.homepage     = "https://github.com/asd39715/LWQ_NavigationHelper.git"

  s.license      = "MIT"

  s.author             = { "asd39715" => "w327177547@163.com" }
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/asd39715/LWQ_NavigationHelper.git", :tag => "0.0.1" }

  s.source_files  = "Classes/**/*"

  s.frameworks = "QuartzCore", "Foundation", "UIKit"

  s.requires_arc = true

end
