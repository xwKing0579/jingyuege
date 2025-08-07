# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'



target 'DeepBooks' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DeepBooks
  pod 'WCDB'
  pod 'HWPanModal'
  pod 'Reachability'
  pod 'JXCategoryView'
  pod 'SDWebImage'
  pod 'YYModel'
  pod 'MJRefresh'
  pod 'Masonry'

  pod 'Alamofire'
  pod 'YYText'

  pod 'IQKeyboardManagerSwift'
  pod 'MediatomiOS','2.8.4.3.2'
  pod 'MediatomiOS/SFAdCsjAdapter'
  pod 'MediatomiOS/SFAdGdtAdapter'
  pod 'MediatomiOS/SFAdKsAdapter'
  pod 'MediatomiOS/SFAdBaiduAdapter'
  
  pod 'SAMKeychain'
  pod 'ZFPlayer/AVPlayer'
  
  pod "DKImagePickerController"
  
  pod 'SVProgressHUD'
  
  pod 'UMCommon'
  pod 'UMDevice'
  pod 'UMLink'
  pod 'UYuMao'
  pod 'UMAPM'
  pod 'UMPush'
  
  pod 'iCarousel'
  pod 'IGListKit'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.1'
    end
  end
end

