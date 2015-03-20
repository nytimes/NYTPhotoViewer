Pod::Spec.new do |s|
  s.name             = "NYTPhotoViewer"
  s.version          = "0.1.1"
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
  s.resources = 'Pod/Assets/**/*'

  s.frameworks = 'UIKit', 'Foundation'
end
