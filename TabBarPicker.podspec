#
# Be sure to run `pod lib lint TabBarPicker.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name                  = "TabBarPicker"
    s.version               = "1.0"
    s.summary               = "TabBarPicker."
  #s.description          = ""
    s.homepage              = "https://github.com/giuseppenucifora/TabBarPicker"
  # s.screenshots         = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
    s.license               = 'MIT'
    s.author                = { "Giuseppe Nucifora" => "me@giuseppenucifora.com" }
    s.source                = { :git => "https://github.com/giuseppenucifora/TabBarPicker.git", :tag => s.version.to_s }
  # s.social_media_url    = 'https://twitter.com/<TWITTER_USERNAME>'

    s.platform              = :ios, '8.0'
    s.requires_arc          = true

    s.source_files          = 'Pod/Classes/**/*'
    s.resource_bundles      = {
        'TabBarPicker' => ['Pod/Assets/*.png']
    }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks          = 'UIKit', 'MapKit'
    s.dependency 'PureLayout'
    s.dependency 'UIView-Overlay'
    s.dependency 'UIActionSheet-Blocks'
    s.dependency 'UIAlertViewBlockExtension'
end
