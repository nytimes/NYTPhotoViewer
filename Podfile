deploymentTarget = '12.0'
platform :ios, deploymentTarget
use_frameworks! :linkage => :static


target 'Example' do
	pod 'NYTPhotoViewer', :path => '.'
end

target 'Example-Swift' do
	pod 'NYTPhotoViewer', :path => '.'
end

# target 'NYTPhotoViewer' do
# #   pod 'PINRemoteImage/iOS', '~> 3.0.3'
# #   pod 'PINRemoteImage/PINCache'
# 
#   target 'NYTPhotoViewerTests' do
# 	pod 'OCMock'
#   end
# 
# end
# 
# target 'NYTPhotoViewerCore' do
# end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
