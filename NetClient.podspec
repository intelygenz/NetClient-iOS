Pod::Spec.new do |s|
  s.name             = 'NetClient'
  s.version          = '0.2.2'
  s.summary          = 'Versatile HTTP networking library written in Swift 3.'

  s.homepage         = 'https://github.com/intelygenz/NetClient-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { 'Alex Rupérez' => 'alejandro.ruperez@intelygenz.com' }
  s.source           = { :git => 'https://github.com/intelygenz/NetClient-iOS.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/intelygenz'
  s.screenshot       = 'https://raw.githubusercontent.com/intelygenz/NetClient-iOS/master/Net.png'

  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  s.framework        = 'Foundation'
  s.module_name      = 'Net'
  s.default_subspecs = 'Core', 'URLSession'
  
  s.subspec 'Core' do |ss|
    ss.source_files = "Core/*.{h,swift}"
  end
  
  s.subspec 'URLSession' do |ss|
    ss.dependency 'NetClient/Core'
    ss.source_files = "URLSession/*.{h,swift}"
  end
  
  s.subspec 'Alamofire' do |ss|
    ss.dependency 'NetClient/Core'
	ss.dependency 'Alamofire', '~> 4.1'
    ss.source_files = "Alamofire/*.{h,swift}"
  end
  
  s.subspec 'Moya' do |ss|
    ss.dependency 'NetClient/Core'
	ss.dependency 'Alamofire', '~> 4.1'
	ss.dependency 'Moya', '~> 8.0'
    ss.source_files = "Moya/*.{h,swift}"
  end
  
  s.subspec 'Kommander' do |ss|
    ss.dependency 'NetClient/URLSession'
	ss.dependency 'Kommander', '~> 0.7'
    ss.source_files = "Kommander/*.{h,swift}"
  end
end
