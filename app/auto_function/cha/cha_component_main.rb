module ChaComponent
  def main
    UIApplication.sharedApplication.delegate
  end

  def change_root_view(view)
    main.instance_variable_get('@window').setRootViewController(view)
  end

  def push(view, bool=true, hide=true)
    view.hidesBottomBarWhenPushed = hide
    self.navigationController.pushViewController(view, animated:bool)
  end

  def show(view, bool=true)
    # NOTE: -[UIViewController presentModalViewController] is deperated!
    self.presentViewController(view, animated:bool, completion: nil)
    # self.presentModalViewController(view, animated:true)
  end

  def hide(bool=true)
    self.dismissModalViewControllerAnimated(bool)
  end

  def pop(bool=true)
    self.navigationController.popViewControllerAnimated(bool)
  end

  def pop_to_root(bool=true)
    self.navigationController.popToRootViewControllerAnimated(bool)
  end

  def status_bar(bool=false)
    UIApplication.sharedApplication.setStatusBarHidden(!bool, animated:false)
  end

  # '0,0,0,0' = 'x,y,w,h', 若x为负数则表示向右对齐

  def get_frame(str)
    if str.nil?
      warn('frame为nil')
      return [[0,0],[0,0]]
    end

    return str if str.class == Array

    frame = str.split(',')
    x = frame[0].to_i < 0 ? (320 - frame[2].to_i - frame[0].to_i.abs) : frame[0].to_i
    y = frame[1].to_i
    [[x, y], [frame[2].to_i, frame[3].to_i]]
  end

  def full_view(color='#FFFFFF', opacity=1)
    frame = [[0,0], [UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height]] 
    view  = UIView.alloc.initWithFrame(frame)
    view.backgroundColor = "#{color}".to_color.colorWithAlphaComponent(opacity)
    view
  end

  def create_view(frame, color='#FFFFFF', opacity=1, shadow=false)
    frame = get_frame(frame)
    view = UIView.alloc.initWithFrame(frame)
    opacity = 1 if opacity.nil?
    view.backgroundColor = "#{color}".to_color.colorWithAlphaComponent(opacity)
    if shadow
      #view.layer.masksToBounds = NO
      #view.layer.cornerRadius = 8
      view.layer.shadowOffset = CGSizeMake(1, 2)
      view.layer.shadowRadius = 1
      view.layer.shadowOpacity = 0.3
    end
    view
  end

  def line(frame, color='#ECECEC')
    separator                 = CALayer.layer
    separator.frame           = frame
    separator.backgroundColor = color.uicolor.CGColor
    separator
  end

  def label(text, frame, size=16, bold=false, color='#000000', background=nil, shadow=false, shadow_color='#CCCCCC', align=nil)
    frame                    = get_frame(frame)
    lbl 			               = UILabel.alloc.initWithFrame(frame)
    lbl.text                 = text.to_s
    
    if background.nil?
      lbl.backgroundColor = UIColor.clearColor
    else
      lbl.backgroundColor = "#{background}".to_color
    end

    lbl.highlightedTextColor = :white.uicolor

    lbl.textColor       = color.uicolor unless color.nil?
    font_size           = size.nil? ? 16 : size
    lbl.font 		        = bold ? UIFont.boldSystemFontOfSize(font_size) :
      UIFont.systemFontOfSize(font_size)

    case align
    when nil, :left, 'left'
      lbl.textAlignment   = UITextAlignmentLeft
    when :right,  'right'
      lbl.textAlignment   = UITextAlignmentRight
    when :center, 'center'
      lbl.textAlignment   = UITextAlignmentCenter
    end

    if shadow
      shadow_color      = '#CCCCCC' if shadow_color.nil?
      lbl.shadowColor   = shadow_color.to_color
      lbl.shadowOffset  = CGSizeMake(0, 1)
    end
    lbl
  end

  #自适应高度label
  def context(text, frame, font_size = 16, color='#000000', absolute=true, align=nil, length=nil)
    frame = get_frame(frame)
    color     ||= '#000000'
    font_size ||= 16
    text      = text[0...length].strip.gsub(/<\/?[^>]*>/, '').strip.gsub(/&nbsp;/, '') unless length.nil?
    lbl                 = UILabel.new
    lbl.backgroundColor = :clear.uicolor
    lbl.textColor       = color.uicolor
    lbl.highlightedTextColor = :white.uicolor

    font      = :system.uifont(font_size)

    size      = text.to_s.sizeWithFont(font,
                                       constrainedToSize:CGSizeMake(frame[1][0], 2000.0),
                                       lineBreakMode:UILineBreakModeWordWrap)

    if absolute == false
      lbl.frame = CGRectMake(frame[0][0], frame[0][1], frame[1][0], size.height)
    else
      lbl.frame = frame
    end

    case align
    when nil, :left, 'left' then lbl.textAlignment = UITextAlignmentLeft
    when :right,  'right'   then lbl.textAlignment = UITextAlignmentRight
    when :center, 'center'  then lbl.textAlignment = UITextAlignmentCenter
    end

    lbl.font = font
    lbl.numberOfLines = 0
    lbl.lineBreakMode = UILineBreakModeWordWrap
    lbl.text   = text
    lbl
  end

  def button(text, frame, size=16, color='#1D92B5', action=nil, param=nil, align=nil)
    size  ||= 16
    color ||= '#1D92B5'
    frame = get_frame(frame)

    button                 = UIButton.alloc.initWithFrame(frame)
    button.titleLabel.font = :bold.uifont(size)
    button.setTitle(text, forState:UIControlStateNormal)
    button.setTitleColor(color.uicolor, forState:UIControlStateNormal)
    button.setTitleColor(:darkgray.uicolor, forState:UIControlStateHighlighted)

    case align
    when nil, :center, 'center'
      button.setContentHorizontalAlignment(UIControlContentHorizontalAlignmentCenter)
    when :right,  'right'
      button.setContentHorizontalAlignment(UIControlContentHorizontalAlignmentRight)
    when :left, 'left'
      button.setContentHorizontalAlignment(UIControlContentHorizontalAlignmentLeft)
    end


    case action
    when 'back' then button.on(:touch) { pop }
    when 'hide' then button.on(:touch) { hide }
    when 'user' then button.on(:touch) { push UserDetail.alloc.initWithId(param) } # TODO: Decouple UserDetail
    else
      unless action.nil?
        if param.nil?
          button.on(:touch) { send(action) }
        else
          button.on(:touch) { send(action, param) }
        end
      end
    end

    button
  end

  def change_btn_image(btn, name)
    btn.setImage(name.uiimage, forState:UIControlStateNormal)
  end

  def image_btn(name, frame, action=nil, param=nil)
    frame = get_frame(frame)
    button = UIButton.alloc.initWithFrame frame
    if name.include? ','
      val = name.split(",")
      button.setImage(val[0].uiimage, forState:UIControlStateNormal)
      button.setImage(val[1].uiimage, forState:UIControlStateHighlighted)
      
    else
      button.setImage(name.uiimage, forState:UIControlStateNormal)
    end

    case action
    when 'back' then button.on(:touch) { pop }
    when 'hide' then button.on(:touch) { hide }
    else
      unless action.nil?
        if param.nil?
          button.on(:touch) { send(action) }
        else
          button.on(:touch) { send(action, param, button) }
        end
      end
    end

    button
  end

  def button_remote_image(url, frame, placeholder='photo', action='back', param=nil, align=nil)
    url         = url.to_s
    placeholder = placeholder.to_s

    button = UIButton.alloc.initWithFrame frame

    if url.downcase.include? 'http'
      button.setImageWithURL(url.nsurl, placehoderImage:placeholder.uiimage)
    else
      button.setImage(url.uiimage, forState:UIControlStateNormal)
    end

    case action
    when 'back' then button.on(:touch) { pop }
    when 'hide' then button.on(:touch) { hide }
    when 'user' then button.on(:touch) { push UserDetail.alloc.initWithId(param) }
    else
      unless action.nil?
        if param.nil?
          button.on(:touch) { send(action) }
        else
          button.on(:touch) { send(action, param, button) }
        end
      end
    end

    button
  end

  def image(url, frame, placeholder='photo', fit=false)
    placeholder ||= 'photo'

    frame = get_frame(frame)
    image_view = UIImageView.alloc.initWithFrame frame

    if url.nil?
      image_view.image = placeholder.uiimage
    elsif url.class == UIImage
      image_view.image = url
    elsif url.downcase.include? 'http'
      image_view.setImageWithURL(url.nsurl, placehoderImage:placeholder.uiimage)

      if fit
        image_view.contentMode   = UIViewContentModeScaleAspectFill
        image_view.clipsToBounds = true

        # image_view.setImageWithURL(url.nsurl,
        #                     success:-> image, cached do
        #                        ratio = image.size.width / 320
        #                        height= 200 #frame[1][1]
        #                        rect = [[0, 0], [image.size.width, height * ratio]]
        #                        imageRef = CGImageCreateWithImageInRect(image.CGImage, rect)
        #                        img = UIImage.imageWithCGImage imageRef
        #                        CGImageRelease(imageRef)
        #                        image_view.image = img
        #                     end, failure:nil)

      end

      # warn("1:#{url}")
    elsif url.class == String
      
      image_view.image = url.uiimage

    else
      image_view.image = placeholder.uiimage
    end

    image_view
  end

  def scroll(array, frame)
    width      = frame[1][0]
    height     = frame[1][1]
    scroll_view = UIScrollView.alloc.initWithFrame(frame)
    scroll_view.contentSize    = CGSizeMake(width * array.length, height)
    scroll_view.pagingEnabled  = true

    elements   = []
    0.upto(array.length-1) do |index|

      array[index].each do |element|
        frame  = get_frame(element[:frame])
        x      = frame[0][0] + width * index
        frame  = [[x, frame[0][1]], [frame[1][0], frame[1][1]]]
        value  = element[:value]

        case element[:type]
        when 'label'
          elements << label(value, frame, element[:size], element[:bold], element[:color],
                            element[:background], element[:shadow], element[:shadow_color])
        when 'image'
          elements << image(value, frame)
        end
      end
    end
    add_subviews(scroll_view, elements)

    scroll_view
  end

  def map(location ,frame, span=0.1, type='standard', show_me=false)
    map_view = MKMapView.alloc.initWithFrame(frame)
    map_view.mapType = (type == 'satellite') ? MKMapTypeSatellite : MKMapTypeStandard

    # 显示用户当前的坐标
    map_view.showsUserLocation=true if show_me
    region                     = MKCoordinateRegion.new
    region.center.latitude     = location[0]
    region.center.longitude    = location[1]

    span = 0.1 if span.nil?
    region.span.latitudeDelta  = span
    region.span.longitudeDelta = span
    map_view.region            = region
    map_view.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

    map_view
  end


  def web(url, frame)
    webView = UIWebView.alloc.initWithFrame(frame)
    request = NSURLRequest.requestWithURL(NSURL.URLWithString(url))
    webView.loadRequest request
    webView
  end

  def custom_item(view)
    UIBarButtonItem.alloc.initWithCustomView(view)
  end

  def bar_item(title, action_name)
    item = UIBarButtonItem.alloc.initWithTitle(title,
                                               style:UIBarButtonItemStyleBordered,
                                               target:self,
                                               action:action_name)
    item
  end

  # 系统add按扭
  def add_item(action_name)
    item = UIBarButtonItem.alloc.
      initWithBarButtonSystemItem(UIBarButtonSystemItemAdd,
                                  target:self,
                                  action:action_name)
    item
  end

  def textfield(frame, placeholder='', text='', is_secure=false)
    field                 = UITextField.alloc.initWithFrame(frame)
    field.placeholder     = placeholder.to_s
    field.secureTextEntry = is_secure
    field.borderStyle     = UITextBorderStyleNone
    # UITextBorderStyleRoundedRect
    field.returnKeyType   = UIReturnKeyNext
    field.delegate        = self
    field.text            = text.to_s
    field
  end

  def password_field(frame, placeholder='', text='')
    textfield(frame, placeholder.to_s, text.to_s, true)
  end

  def add_subviews(view, objs)
    # if !objs.kind_of? Array
    #   puts "not a array"
    #   return view 
    # end

    objs.each { |obj| view.addSubview(obj) if !obj.nil? }
    view
  end


  def friendly_time(from_time, include_seconds = false)
    distance_in_minutes = (((from_time - Time.now).abs)/60).round
    distance_in_seconds = ((from_time - Time.now).abs).round

    case distance_in_minutes
    when 0..1
      return (distance_in_minutes == 0) ? '不到 1 分钟' : '1 分钟' unless include_seconds
      case distance_in_seconds
      when 0..4   then '刚刚'
      when 5..9   then '不到10秒'
      when 10..19 then '不到20 秒'
      when 20..39 then '半分钟前'
      when 40..59 then '不到 1 分钟'
      else             '1 分钟'
      end

    when 2..44           then "#{distance_in_minutes} 分钟前"
    when 45..89          then '1 小时前'
    when 90..1439        then "#{(distance_in_minutes.to_f / 60.0).round} 小时前"
    when 1440..2879      then '1 天前'
    when 2880..43199     then "#{(distance_in_minutes / 1440).round} 天前"
    when 43200..86399    then '1 个月前'
    when 86400..525599   then "#{(distance_in_minutes / 43200).round} 个月"
    when 525600..1051199 then '1 年左右'
    else                      "#{(distance_in_minutes / 525600).round} 年"
    end
  end


  def get_content_height(str, width=320, size=15)
    font = :system.uifont(size)
    size = str.to_s.sizeWithFont(font, constrainedToSize:CGSizeMake(width, 5000.0),
                                 lineBreakMode:UILineBreakModeCharacterWrap)
    size.height
  end

  def nav_with_view(view)
    UINavigationController.alloc.initWithRootViewController(view)
  end

  # 警报函数
  # 参数：消息 + 触发条件
  def warn(msg, bool=true)
    if bool
      puts "================= ChaMotionRender:Warning ==============="
      puts "                                                         "
      puts "  #{msg}  "
      puts "                                                         "
      puts "========================================================="
    end
    bool
  end

  # 兼容iPhone 5
  def fit_height(height)
    screenBounds = UIScreen.mainScreen.bounds
    height += 88 if screenBounds.size.height == 568
    height
  end

  def empty_cell
    cell = UITableViewCell.alloc.init
    cell.contentView.subviews.each do |subview|
      subview.removeFromSuperview
    end
    cell
  end
    
end
