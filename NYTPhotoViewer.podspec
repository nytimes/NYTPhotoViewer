Pod::Spec.new do |s|
  s.name             = "NYTPhotoViewer+LifeCycle"
  s.version          = "0.1.2.1"
  s.description      = <<-DESC
                       NYTPhotoViewer is a slideshow and image viewer that includes double tap to zoom, captions, support for multiple images, interactive flick to dismiss, animated zooming presentation, and more.
                       DESC
  s.summary          = "NYTPhotoViewer is a slideshow and image viewer that includes double tap to zoom, flick to dismiss, animated presentation, and more."
  s.homepage         = "https://github.com/NYTimes/NYTPhotoViewer"
  s.author           = "Sergio García"
  s.license          = { :type => 'Apache 2.0' }
  s.source           = { :git => "https://github.com/sergiog90/NYTPhotoViewer.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resources = 'Pod/Assets/**/*'

  s.frameworks = 'UIKit', 'Foundation'
end
