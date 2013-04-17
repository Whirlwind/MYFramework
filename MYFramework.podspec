Pod::Spec.new do |s|
  s.name         = "MYFramework"
  s.version      = "1.1"
  s.summary      = "a based Router framework."
  s.homepage     = "https://github.com/Whirlwind/MYFramework"
  s.license      = 'MIT'
  s.author       = { "Whirlwind" => "Whirlwindjames@foxmail.com" }
  s.source       = { :git => "https://github.com/Whirlwind/MYFramework.git", :tag=>'v1.1'}
  s.platform     = :ios
  s.source_files = 'src/**/*.{h,m}'
  s.resources = "resources/**/*.png", "src/*.{broadcast,route}"
  s.frameworks = 'UIKit', 'Foundation', 'QuartzCore', 'MobileCoreServices', 'CoreGraphics'
  s.prefix_header_file = 'src/MYFramework-Prefix.pch'
  s.requires_arc = true

  s.dependency 'NSUserDefaults+AppVersion'
  s.dependency 'UIView'
  s.dependency 'NSDate'
  # s.dependency 'FMDB'
  s.dependency 'NSString'
  # s.dependency 'ASIHTTPRequest/Basic'
  # s.dependency 'JSONAPI'
  # s.dependency 'BHAnalysis'
  s.dependency 'VersionString'
  # s.dependency 'MTStatusBarOverlay'
  s.dependency 'IXPickerOverlayView'
end
