Pod::Spec.new do |s|
  s.name             = 'NetClient'
  s.version          = '0.1.0'
  s.summary          = 'A Swift library written in Swift 3'

  s.homepage         = 'https://github.com/intelygenz/NetClient-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'Alex Rupérez' => 'alejandro.ruperez@intelygenz.com' }
  s.source           = { :git => 'https://github.com/intelygenz/NetClient-iOS.git', :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/intelygenz"

  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'

  s.source_files     ="Core/*.{h,swift}"
end

