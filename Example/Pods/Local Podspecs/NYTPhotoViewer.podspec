#
# Be sure to run `pod lib lint NYTPhotoViewer.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "NYTPhotoViewer"
  s.version          = "0.1.0"
  s.summary          = "A short description of NYTPhotoViewer."
  s.description      = <<-DESC
                       An optional longer description of NYTPhotoViewer

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/nytm/ios-photo-viewer"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Brian Capps" => "Brian.Capps@nytimes.com" }
  s.source           = { :git => "https://github.com/nytm/ios-photo-viewer.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/bcapps'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'NYTPhotoViewer' => ['Pod/Assets/**/*.{png,lproj,storyboard}']
  }

  s.frameworks = 'UIKit', 'Foundation'
end
