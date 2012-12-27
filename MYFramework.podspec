class Pod::Spec
  @@git_plugins_url = 'git@boohee-apple:/opt/git/Plugins'

  def dependency_git(name, other={})
    other[:git] = "#{@@git_plugins_url}/#{name}.git"
    self.dependency name, other
  end
end

Pod::Spec.new do |s|
  s.name         = "MYFramework"
  s.version      = "1.0"
  s.summary      = "a based Router framework."
  s.homepage     = "http://EXAMPLE/MYFramework"
  s.license      = 'MIT'
  s.author       = { "Whirlwind" => "james@boohee.com" }
  s.source       = { :git => "git@boohee-apple:/opt/git/Plugins/MYFramework.git", :tag=>'v1.0'}
  s.platform     = :ios
  s.source_files = 'src/**/*.{h,m}'
  s.resources = "resources/**/*.png"
  s.frameworks = 'UIKit', 'Foundation', 'QuartzCore'
  s.prefix_header_file = 'src/MYFramework-Prefix.pch'

  s.dependency 'UIView', '~>0.0.1'
  s.dependency 'NSDate', '~>0.0.3'
  s.dependency_git 'Kal', :branch => 'KalView_picker'
end
