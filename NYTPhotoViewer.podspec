Pod::Spec.new do |s|
  s.name             = "NYTPhotoViewer"
  s.version          = "0.1.2"
  s.summary          = "NYTPhotoViewer is a slideshow and image viewer that includes double tap to zoom, captions, support for multiple images, interactive flick to dismiss, animated zooming presentation, and more."
  s.homepage         = "https://github.com/NYTimes/NYTPhotoViewer"
  s.source           = { :git => "git@github.com:NYTimes/NYTPhotoViewer.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resources = 'Pod/Assets/**/*'

  s.frameworks = 'UIKit', 'Foundation'
end
