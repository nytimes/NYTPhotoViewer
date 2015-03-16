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
  s.summary          = "NYTPhotoViewer is a pod for viewing images. It handles one or multiple images in a slideshow format."
  s.description      = <<-DESC
                       NYTPhotoViewer is a pod for viewing images. It handles one or multiple images in a slideshow format, and includes robust customization options through its delegate relationship. The photo viewer also handles custom UIViewController transitions, including zooming and flick-to-dismiss.
                       DESC
  s.homepage         = "https://github.com/nytm/ios-photo-viewer"
  s.author           = { "Brian Capps" => "Brian.Capps@nytimes.com" }
  s.source           = { :git => "https://github.com/nytm/ios-photo-viewer.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'NYTPhotoViewer' => ['Pod/Assets/**/*.{png,lproj,storyboard}']
  }

  s.frameworks = 'UIKit', 'Foundation'
end
