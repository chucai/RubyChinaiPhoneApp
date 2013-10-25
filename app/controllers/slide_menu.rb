# -*- encoding : utf-8 -*-
class SlideMenu < UIViewController
  include ChaComponent

  MENU      = %w(主题 会员)
  # MENU_ICON = [%w(my feed message), %w(quan recent), %w(company school ngo), %w(invite review)] 
  MENU_HEIGHT = 45

  def loadView
    super
    view.backgroundColor = '#FFFFFF'.uicolor
    init_menu
  end  

  def viewDidLoad
    super
    self.revealController.setMinimumWidth(220.0,maximumWidth:244.0, forViewController:self)
  end

  def init_menu

    width  = 200
    height = view.bounds.size.height
    color  = '#424347'

    bg  = create_view([[0,0], [width, height]], '#FFFFFF')

    table_view                  = UITableView.new
    table_view.delegate         = self
    table_view.dataSource       = self
    table_view.frame            = [[0, 0], [width, height]]
    table_view.autoresizingMask = UIViewAutoresizingFlexibleHeight
    table_view.backgroundColor = color.uicolor 
    table_view.separatorStyle   = UITableViewCellSeparatorStyleNone
    menu_bg                     = UIImageView.new
    menu_bg.image               = 'menu-bg'.uiimage

    table_view.backgroundView   = menu_bg
    bg << table_view

    view << bg
    # @table_view.addPullToRefreshWithActionHandler -> { reload_data } if @list_url
  end


  def tableView(tableView, cellForRowAtIndexPath:indexPath)
      cell = empty_cell
      cell.selectionStyle = UITableViewCellSelectionStyleNone

      # icon_name = 'menu-' + MENU_ICON[indexPath.section-1][indexPath.row] if indexPath.section > 0
      # cell << image(icon_name, [[20,15], [19,19]])
      cell << label(MENU[indexPath.row], [[55,15], [150,22]], 16, false, '#FFFFFF')
      cell
  end

  def account_cell

  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)

  end

  def change(screen_class)
    App.delegate.slide_menu.content_controller = screen_class.new
  end

  def tableView(tableView, viewForHeaderInSection:section)
    bg = create_view([[0,0], [200,1]], '#5A5A5A')    
  end

  def tableView(tableView, heightForHeaderInSection:section)
    # section == 0 ? 0 : 1
  end

  def numberOfSectionsInTableView(tableView)
    1# MENU.length
  end

  def tableView(tableView, numberOfRowsInSection:section)
    2# [1,3,2,3,2][section]
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    MENU_HEIGHT
  end

end