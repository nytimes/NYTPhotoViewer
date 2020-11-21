platform :ios, '12.0'
use_frameworks!

target 'Example' do
	pod 'NYTPhotoViewer', :path => './NYTPhotoViewer'
end

target 'Example-Swift' do
end

target 'NYTPhotoViewer' do
  pod 'PINRemoteImage/iOS', '~> 3.0.1'
  pod 'PINRemoteImage/PINCache'

  target 'NYTPhotoViewerTests' do
	pod 'OCMock'
  end

end

target 'NYTPhotoViewerCore' do
  # Pods for NYTPhotoViewerCore

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
