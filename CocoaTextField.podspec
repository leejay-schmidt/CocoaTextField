Pod::Spec.new do |spec|
  spec.name         = "CocoaTextField"
  spec.version      = "1.0.1"
  spec.summary      = "Highly customizable text field created according to Material.IO guidelines. (Fork from Edgar Zigis)"

  spec.homepage     = "https://github.com/leejay-schmidt/CocoaTextField"
  spec.screenshots  = "https://raw.githubusercontent.com/leejay-schmidt/CocoaTextField/master/sample.gif"

  spec.license      = { :type => 'MIT', :file => './LICENSE' }

  spec.author       = "Leejay Schmidt"

  spec.platform     = :ios
  spec.ios.deployment_target = '11.0'
  spec.swift_version = '5.0'
  
  spec.source       = { :git => "https://github.com/leejay-schmidt/CocoaTextField.git", :tag => "#{spec.version}" }

  spec.source_files  = "CocoaTextField/**/*.{swift}"
end
