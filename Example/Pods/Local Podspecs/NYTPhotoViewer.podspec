Pod::Spec.new do |s|
  s.name             = "NYTPhotoViewer"
<<<<<<< HEAD
  s.version          = "0.1.2"
  s.description      = <<-DESC
                       NYTPhotoViewer is a slideshow and image viewer that includes double tap to zoom, captions, support for multiple images, interactive flick to dismiss, animated zooming presentation, and more.
                       DESC
  s.summary          = "NYTPhotoViewer is a slideshow and image viewer that includes double tap to zoom, flick to dismiss, animated presentation, and more."
  s.homepage         = "https://github.com/NYTimes/NYTPhotoViewer"
  s.author           = "The New York Times"
  s.license          = { :type => 'Apache 2.0' }
  s.source           = { :git => "https://github.com/NYTimes/NYTPhotoViewer.git", :tag => s.version.to_s }
=======
  s.version          = "0.1.1"
  s.summary          = "NYTPhotoViewer is a pod for viewing images. It handles one or multiple images in a slideshow format."
  s.description      = <<-DESC
                       NYTPhotoViewer is a pod for viewing images. It handles one or multiple images in a slideshow format, and includes robust customization options through its delegate relationship. The photo viewer also handles custom UIViewController transitions, including zooming and flick-to-dismiss.
                       DESC
  s.homepage         = "https://github.com/nytm/ios-photo-viewer"
  s.author           = { "Brian Capps" => "Brian.Capps@nytimes.com" }
  s.source           = { :git => "git@github.com:nytm/ios-photo-viewer.git", :tag => s.version.to_s }
>>>>>>> pod install

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resources = 'Pod/Assets/**/*'

  s.frameworks = 'UIKit', 'Foundation'
end
