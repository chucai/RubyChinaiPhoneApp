# -*- encoding : utf-8 -*-
class SlideMenu < UIViewController
  include ChaComponent

  MENU      = %w(张泽涛 动态 私信 恰恰网络 华南理工大学 评分 邀请)
  MENU_ICON = [%w(my feed message), %w(quan recent), %w(company school ngo), %w(invite review)] 
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
    menu_bg               = UIImageView.new
    menu_bg.image          = 'menu-bg'.uiimage

    table_view.backgroundView   = menu_bg
    bg << table_view

    view << bg
    # @table_view.addPullToRefreshWithActionHandler -> { reload_data } if @list_url
  end


  def tableView(tableView, cellForRowAtIndexPath:indexPath)
      cell = empty_cell
      case indexPath.section
      when 0
        text = %w(张泽涛)
      when 1 
        text = %w(我的 动态 私信)
      when 2
        text = %w(圈子 最近的圈子)
      when 3
        text = %w(公司 学校 组织)
      when 4
        text = %w(邀请 评分)
      end
      cell.selectionStyle = UITableViewCellSelectionStyleNone

      # icon_name = 'menu-' + MENU_ICON[indexPath.section-1][indexPath.row] if indexPath.section > 0
      # cell << image(icon_name, [[20,15], [19,19]])
      cell << label(text[indexPath.row], [[55,15], [150,22]], 16, false, '#FFFFFF')
      cell
  end

  def account_cell

  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)

      case indexPath.section
      when 0
        
      when 1
        case indexPath.row
        when 0
          change Me
        when 1
          change Feed
        when 2
          change MessageList
        end

      when 2
        if indexPath.row == 0 # 圈子
          change QuanList
        else
          # 最近的圈子

        end
      when 3 # 公司,学校,组织
        case indexPath.row
        when 0
          change CompanyList
        when 1
          change SchoolList
        when 2
          change NgoList
        end
      when 4 # 邀请,评分
        if indexPath.row == 0
          change Invite
        else
          App.open_url(Config::DOWNLOAD_URL)
        end
      end
  end

  def change(screen_class)
    App.delegate.slide_menu.content_controller = screen_class.new
  end

  def tableView(tableView, viewForHeaderInSection:section)
    bg = create_view([[0,0], [200,1]], '#5A5A5A')    
  end

  def tableView(tableView, heightForHeaderInSection:section)
    section == 0 ? 0 : 1
  end

  def numberOfSectionsInTableView(tableView)
    5
  end

  def tableView(tableView, numberOfRowsInSection:section)
    [1,3,2,3,2][section]
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    MENU_HEIGHT
  end

end