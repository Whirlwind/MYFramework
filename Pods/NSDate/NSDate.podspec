Pod::Spec.new do |s|
  s.name         = "NSDate"
  s.version      = "0.0.1"
  s.summary      = "some categories of NSDate."
  s.homepage     = "http://EXAMPLE/NSDate"
  s.license      = 'MIT'
  s.author       = { "Whirlwind" => "james@boohee.com" }
  s.source       = { :git => "git@boohee-apple:/opt/git/Plugins/NSDate.git", :tag => "v0.0.1" }
  s.platform     = :ios
  s.source_files = '*.{h,m}'
end
