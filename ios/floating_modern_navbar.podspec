Pod::Spec.new do |s|
  s.name             = 'floating_modern_navbar'
  s.version          = '0.2.1'
  s.summary          = 'Floating navigation with native iOS adaptive placement.'
  s.description      = s.summary
  s.homepage         = 'https://github.com/iamDjang0o/floating_modern_navbar'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'floating_modern_navbar' => 'https://github.com/iamDjang0o' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
