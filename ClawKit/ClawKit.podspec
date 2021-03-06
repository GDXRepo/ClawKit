Pod::Spec.new do |s|
  s.name             = "ClawKit"
  s.version          = "0.1.1"
  s.summary          = "Useful classes for MVVM/MVP/MVC/SOA-based projects."
  s.homepage         = "https://github.com/GDXRepo/ClawKit"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Georgiy Malyukov" => "elvorta.work@gmail.com" }
  s.source           = { :git => "https://github.com/GDXRepo/ClawKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://vk.com/deadlineru'

  s.platform      = :ios, '11.4'
  s.swift_version = '4.2'
  s.requires_arc  = true

  s.resources = ['ClawKit/Pod/Assets/*.xcassets', 'ClawKit/Pod/Assets/*.strings']
  s.source_files = 'ClawKit/Pod/Classes/**/*'

  s.dependency 'SnapKit'
  s.dependency 'SAMKeychain'
  s.dependency 'IQKeyboardManager'
  s.dependency 'R.swift', '>= 5.0.0.alpha.1'
  s.dependency 'TableKit'
end
