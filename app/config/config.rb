# -*- encoding : utf-8 -*-
class Config

  DOWNLOAD_URL  = "http://126.am/rubychina"
  BASE_URL      = "http://ruby-china.org/api/"


  UMENG_APP_KEY = "526a09a456240b8ecc007823"

  WX_APP_ID     = "wx1bd716fc9aa5fe5b"

  SHARE_TEXT    = ""

  URL           = "http://ruby-china.org"
  
  REFRESH_TITLE = "下拉刷新"
  
  DEBUG         = true

  def self.init
    # 友盟统计
    # UMSocialData.openLog(true)
    
    MobClick.startWithAppkey UMENG_APP_KEY
    MobClick.checkUpdate

    # 友盟SNS分享SDK
    UMSocialData.setAppKey UMENG_APP_KEY
    
    # 微信SDK
    WXApi.registerApp WX_APP_ID

    UMSocialConfig.setWXAppId(WX_APP_ID, url:DOWNLOAD_URL)
    
    # UMSocialConfig.setSupportSinaSSO(true)
    
    

    color = UIColor.redColor

    UINavigationBar.appearance.tintColor    = color
    UITabBar.appearance.tintColor           = color
    UIToolbar.appearance.tintColor          = color
  end

end
