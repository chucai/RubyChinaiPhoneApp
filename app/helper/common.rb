module Common

  def nav_bar(title_name, right_name=nil, action=nil)
    bg = create_view([[0,0],[320,45]])
    bg << image('nav-bg', [[0,0],[320,45]])
    bg << image(title_name, [[125,13],[65,19]])
    menu = image_btn('menu', [[0,0],[45,45]])
    menu.on_tap do 
        App.delegate.slide_menu.show_menu
    end

    if right_name
        right_item = image_btn(right_name, [[320-45,0], [45,45]], action)
        bg << right_item
    end
    bg << menu
    bg
  end

  def msg(text, type=:normal)
    case type
    when :success
      SVProgressHUD.showSuccessWithStatus(text)
    when :failure
      SVProgressHUD.showFaiulreWithStatus(text)
    else
      SVProgressHUD.showWithStatus(text)
    end
  end

  def hide_msg
    SVProgressHUD.dismiss
  end

  def footer
    bg = create_view([[0,0],[320,31]], '#FFFFFF', 0)
    bg << image('footer', [[0,0], [320,31]])
    bg
  end
  

  def share_to_sns(text)
    UMSocialSnsService.presentSnsIconSheetView(self,
                                     appKey:Config::UMENG_APP_KEY,
                                  shareText:text,
                                 shareImage:nil,
                            shareToSnsNames:[UMShareToSina, UMShareToTencent, UMShareToWechatSession,
                              UMShareToSms],
                                   delegate:nil)

  end
    
end