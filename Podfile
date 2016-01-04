source 'https://github.com/CocoaPods/Specs.git'
platform :tvos, '9.0'
use_frameworks!

pod 'Alamofire', '~> 3.0'
pod 'SwiftyJSON', '~> 2.3'
pod 'OHHTTPStubs', '~> 4.7'

target 'VideoStationViewer' do

end

target 'VideoStationViewerTests' do

end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['ENABLE_BITCODE'] = 'YES'
		end
	end
end