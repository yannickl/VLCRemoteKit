Pod::Spec.new do |s|
  s.name             = 'VLCRemoteKit'
  s.version          = '1.0.0'
  s.license          = { :type => 'MIT', :file => 'LICENSE' } 
  s.summary          = 'Remote control for VLC in Objective-C'
  s.homepage         = 'https://github.com/YannickL/VLCRemoteKit'
  s.authors          = { 'Yannick Loriot' => 'contact@yannickloriot.com' }
  s.social_media_url = "https://twitter.com/yannickloriot"
  s.source           = { :git => 'https://github.com/YannickL/VLCRemoteKit.git',
                         :tag => s.version.to_s }
  s.requires_arc     = true

  s.source_files     = ['VLCRemoteKit/*.{h,m}']

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
end
