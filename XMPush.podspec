require 'json'
pjson = JSON.parse(File.read('package.json'))

Pod::Spec.new do |s|

  s.name            = "XMPush"
  s.version         = pjson["version"]
  s.homepage        = pjson["homepage"]
  s.summary         = pjson["description"]
  s.license         = pjson["license"]
  s.author          = { "zhangzy" => "zhangzy@5ichong.com" }

  s.ios.deployment_target = '9.0'

  s.source          = { :git => "https://github.com/a289459798/react-native-mipush", :tag => "v#{s.version}" }
  s.source_files    = 'ios/*.{h,m}'
  s.ios.vendored_libraries = 'ios/*.a'
  s.preserve_paths  = "**/*.js"

  s.frameworks = 'UserNotifications','SystemConfiguration','MobileCoreServices','CFNetwork','CoreTelephony'
  s.library = 'resolv','xml2','z'
  s.dependency 'React'
  s.dependency 'RNCPushNotificationIOS'
  s.dependency "UMPush", "4.0.3"
end
