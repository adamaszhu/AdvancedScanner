Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '13.0'
s.name = "AdvancedScanner"
s.summary = "AdvancedScanner contains additional text detection logic."
s.requires_arc = true
s.version = "0.1.1"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Adamas Zhu" => "developer@adamaszhu.com" }
s.homepage = "https://github.com/adamaszhu/AdvancedScanner"
s.source = { :git => "https://github.com/adamaszhu/AdvancedScanner.git",
             :tag => "#{s.version}" }
s.framework = "Foundation", "UIKit"
s.dependency 'AdvancedFoundation', '~> 1.9.0'
s.dependency 'AdvancedUI', '~> 1.9.25', :configurations => ['PHOTO']
s.source_files = "AdvancedScanner/**/*.{swift}"
s.resources = "AdvancedScanner/**/*.{strings}"
s.swift_version = "5"

end
