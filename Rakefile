# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'RubyChina'
  app.version                = '0.1'
  app.short_version          = '0.1'
  app.identifier             = "org.rubychina.app"

  # 开发证书
  app.codesign_certificate = "iPhone Developer: eddie yang"
  # app.provisioning_profile = "/Users/zdance/Library/MobileDevice/Provisioning Profiles/A75E1539-A96D-422C-BF78-F12FAE8897D0.mobileprovision"
  app.provisioning_profile = "/Users/zdance/Library/MobileDevice/Provisioning Profiles/56B79268-3308-4369-8F13-892A964E66EC.mobileprovision"
  

  app.device_family                           = :iphone
  app.interface_orientations                  = [:portrait]
  app.prerendered_icon                        = true
  app.deployment_target                       = '6.0'
  app.icons                                   = ['icon.png', 'icon@2x.png']
  app.info_plist['CFBundleDevelopmentRegion'] = 'zh_CN'

  app.info_plist['CFBundleURLTypes']          = [
    {
      'CFBundleURLName'    => 'weixin',
      'CFBundleURLSchemes' => ['wx1bd716fc9aa5fe5b']
    }
  ]

  app.libs                  += %w(/usr/lib/libz.dylib /usr/lib/libsqlite3.dylib /usr/lib/libiconv.dylib)
  
   # /usr/lib/libiconv.dylib /usr/lib/libstdc++.dylib 

  app.frameworks            += %w(UIKit Foundation CFNetwork SystemConfiguration MobileCoreServices QuartzCore CoreGraphics MessageUI CoreTelephony StoreKit CoreLocation)
    

  app.vendor_project('vendor/MobClick',
                     :static,
                     :products => ['libMobClickLibrary.a'])

  app.vendor_project('vendor/UMSocial', :static,
                     :products => ['libUMSocial_Sdk_3.1.a', 
                      'libUMSocial_Sdk_Comment_3.1.a',
                      'frameworks/WeChat/libWeChatSDK.a'])  

  app.pods do
    # pod 'DTCoreText'
    pod 'JSONKit'
    pod 'SDWebImage'
    pod 'SVProgressHUD'
    pod 'SVPullToRefresh'
    pod 'PKRevealController'
    # pod 'AFNetworking', '~> 2.0'
  end

end
