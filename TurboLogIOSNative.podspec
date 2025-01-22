Pod::Spec.new do |s|
  s.name             = 'TurboLogIOSNative'
  s.version          = '0.1.0'
  s.summary          = 'Native iOS logging library for TurboLog'
  s.description      = <<-DESC
                       The IOS native part of the TurboLog package for logging.
                       DESC
  s.homepage         = 'https://github.com/larkox/react-native-turbo-log-ios-native'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Espino García' => 'larkox@gmail.com' }
  s.source           = { :git => 'https://github.com/larkox/react-native-turbo-log-ios-native.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '11.0'

  s.source_files = 'Sources/TurboLogSwift/**/*'
  s.public_header_files = 'Sources/TurboLogSwift/**/*.h'

  s.frameworks = 'Foundation'  
  s.dependency 'CocoaLumberjack', '~> 3.8.5'
end
