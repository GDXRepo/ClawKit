Pod::Spec.new do |s|
  s.name             = "ClawKit"
  s.version          = "0.0.6"
  s.summary          = "Useful classes for MVVM/MVP/MVC/SOA-based projects."
  s.homepage         = "https://github.com/GDXRepo/ClawKit"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Georgiy Malyukov" => "elvorta.work@gmail.com" }
  s.source           = { :git => "https://github.com/GDXRepo/ClawKit.git", :tag => s.version.to_s }
  s.social_media_url = 'https://vk.com/deadlineru'

  s.platform      = :ios, '11.4'
  s.swift_version = '4.1'
  s.requires_arc  = true

  s.source_files = 'Pod/Classes/**/*'

  s.dependency 'SnapKit'
end
