platform :ios, '13.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

target 'RupeeWallet' do
  pod 'Adjust'
  pod 'Masonry'
  pod 'SDWebImage'
  pod 'MJExtension'
  pod 'AliyunOSSiOS'
  pod 'AFNetworking'
  pod 'Reachability'
  pod 'SVProgressHUD'
  pod 'CRBoxInputView'
  pod 'SVPullToRefresh'
  pod 'IQKeyboardManager'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
