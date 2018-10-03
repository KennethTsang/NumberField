#
# Be sure to run `pod lib lint NumberField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NumberField'
  s.version          = '0.4.2'
  s.summary          = 'Numeric field with Numpad keyboard on both iPhone and iPad'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Numeric field with Numpad keyboard on both iPhone and iPad.
                       DESC

  s.homepage         = 'https://github.com/KennethTsang/NumberField'
  s.screenshots      = "https://raw.githubusercontent.com/KennethTsang/NumberField/master/DEMO.gif"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Kenneth Tsang" => "kenneth.tsang@me.com" }
  s.source           = { :git => "https://github.com/KennethTsang/NumberField.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'NumberField/Classes/**/*'
  
  s.resource_bundles = {
    'NumberField' => ['NumberField/Classes/*.xib']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
