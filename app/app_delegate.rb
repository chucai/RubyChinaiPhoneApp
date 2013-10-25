class AppDelegate < PM::Delegate
  include ChaComponent
  def on_load(app, options)

    Config.init

    root_view = nav_with_view(TopicList.new)
    
    # Scan.alloc.initWithSide(:front))
    root_view.setNavigationBarHidden(true, animated:false) 

    open_slide_menu SlideMenu, root_view
    
    # slide_menu.setMinimumWidth(220.0,maximumWidth:244.0, forViewController:self)
    # slide_menu.setMinimumWidth(220.0, maximumWidth:240.0, forViewController:SlideMenu)
    # You can get to the instance of the slide menu at any time if you need to
    # slide_menu.menu_controller.class.name
    # => NavigationScreen

    # SlideMenuScreen is just an enhanced subclass of PKRevealController, so you can do all sorts of things with it
    # slide_menu.disablesFrontViewInteraction = true
    slide_menu.animationDuration = 0.5

  end

end

