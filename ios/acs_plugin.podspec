#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint acs_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'acs_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'  
  s.dependency 'AzureCommunicationCalling', '2.14.1'
  s.dependency 'AzureCommunicationChat', '1.3.3'
  s.dependency 'MicrosoftFluentUI/Avatar_ios', '0.10.0'
  s.dependency 'MicrosoftFluentUI/BottomSheet_ios', '0.10.0'
  s.dependency 'MicrosoftFluentUI/Button_ios', '0.10.0'
  s.dependency 'MicrosoftFluentUI/PopupMenu_ios', '0.10.0'
  s.dependency 'MicrosoftFluentUI/ActivityIndicator_ios', '0.10.0'
  s.dependency 'MicrosoftFluentUI/AvatarGroup_ios', '0.10.0'
  s.platform = :ios, '16.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'acs_plugin_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
