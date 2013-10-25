# 渲染引擎列表
# 参数：
#
#   layout : 界面定义数组
#   data   : 数据
#   config : 配置
#
# (以上三个参数可本地，亦可从网络获取)
#
#   base_url : 根路径
#   list_url : 列表路径
#   params   : 获取列表参数
#   menu     : 列表菜单数组

class ChaList < UIViewController
  include ChaComponent

  attr_accessor :layout, :data, :config, :top_data
  attr_accessor :base_url, :list_url
  attr_accessor :page, :per_page
  attr_accessor :params, :menu
  attr_accessor :background_color
  attr_accessor :height, :width
  attr_accessor :header_view_height, :footer_view_height
  attr_accessor :line

  def init
    if initWithNibName(nil, bundle:nil)
      @layout             = []
      @data               = []
      @config             = {}
      @loading            = false
      @show_more          = true
      @per_page           = 20
      @params             = {}
      @params[:page]      = 1
      @menu               = []
      @line               = true
      @header_view_height = 0
      @footer_view_height = 0

      # warn('init')
      # 新增内容标记，若为真则刷新
      @add_mark = false
    end

    self
  end



  def viewDidLoad
    super
    return if @list_url.nil? && @layout.nil? && @data.nil? 
    # warn('@layout,@data和list_url都为空', @layout.nil? || @data.nil? || @layout.empty? || @data.empty? || @list_url.nil?)

    initTableView
    load_data

    init_menu
    # warn('load')
  end

  def viewWillAppear(animated)
    super
    navigationController.setNavigationBarHidden(false, animated:true)

    if @add_mark
      reload_data 
      @add_mark = false
    end
    # warn('appear')
  end

  def viewWillDisappear(animated)
    super
    toggle_menu if @menu_visible
    SVProgressHUD.dismiss
    # warn('disappear')
  end  

  def initTableView
    
    @width  ||= view.bounds.size.width
    @height ||= view.bounds.size.height

    @table_view                  = UITableView.plain
    @table_view.delegate         = self
    @table_view.dataSource       = self
    @table_view.frame            = [[0, 0], [@width, @height]]
    @table_view.autoresizingMask = UIViewAutoresizingFlexibleHeight
    @table_view.backgroundColor  = @background_color.uicolor if @background_color
    @table_view.separatorStyle   = @line ? UITableViewCellSeparatorStyleSingleLine
                                        : UITableViewCellSeparatorStyleNone
    view << @table_view
    # warn('tableView')
    @table_view.addPullToRefreshWithActionHandler -> { reload_data } if @list_url

    # warn('initTableView')
  end

  def add_header_and_footer
    if @config[:header_view]
      header_view       = UIView.new
      header_view.frame = [[0,0],[320, @header_view_height]]
      header_view       = render(header_view, @config[:header_view], @data)

      @table_view.tableHeaderView = header_view
    end

    if @config[:footer_view]
      footer_view       = UIView.new
      footer_view.frame = [[0, @height - @header_view_height],[320, @footer_view_height]]
      footer_view       = render(header_view, @config[:footer_view], @data)

      @table_view.tableHeaderView = footer_view
    end
  end

  def reload_data
    @params[:page] = 1
    load_data
    @table_view.pullToRefreshView.stopAnimating
  end

  def load_data
    return if @list_url.nil?
    SVProgressHUD.showWithStatus('正在加载'.localized) if @params[:page] == 1
    # warn('load_data')

    get_data(@list_url, @params) do |response|
      # warn('get_data')
      if response.nil?
        App.alert('网络连接不正常，请调整网络后重新尝试')
      else
        if @params[:page].to_i > 1
          @data   += response.object["data"]
        else
          @layout   = response.object["layout"]   || @layout
          @config   = response.object["config"]   || @config
          @data     = response.object["data"]     || @data
          @top_data = response.object["top_data"] || @top_data
        end

        @loading = false
        
      end

      @table_view.reloadData
      add_header_and_footer
      SVProgressHUD.dismiss
    end

    # warn('load_data')
  end

  def row_data(indexPath)
    index  = indexPath.row
    index -= 1 if config[:top_cell]

    @config[:json].blank? ? @data[index] : @data[index][@config[:json]]
  end

  def tableView(tableView, numberOfRowsInSection:section)
    return 1 if @data.length == 0
    count = @data.length
    count += 1 if show_more?(count)
    count += 1 if @config[:top_cell]
    count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    # 空Cell
    if @data.length == 0
      nodata_cell  # 没有内容
    elsif indexPath.row == 0 && @config[:top_cell]
      top_cell     # 顶部Cell
    elsif @config[:twitter_cell]
      data = row_data(indexPath)
      cell = twitter_cell(data)
      cell.accessoryType = UITableViewCellAccessoryNone
      cell
    elsif is_loadmore_cell? indexPath
      loading_cell # 加载更多Cell
    else
      # 一般cell
      cell = empty_cell
      data = row_data(indexPath)
      render(cell, @layout, data)

      cell.selectionStyle = UITableViewCellSelectionStyleNone if @config[:selection] == 'none'

      case @config[:accessor]
      when nil, 'none' then cell.accessoryType = UITableViewCellAccessoryNone
      when 'indicator' then cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      when 'button'    then cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
      end

      cell
    end
  end

  def nodata_cell
    layout = @config[:blank_cell]
    if layout.blank?
      blank_cell
    elsif layout.class == String
      @blank_cell_string ||= layout
      blank_cell_with_string(@blank_cell_string)
    else
      cell  =  empty_cell
      render(cell, layout, @data)
    end
  end


  def is_loadmore_cell?(indexPath)
    if @config[:top_cell]
      indexPath.row == @data.length + 1
    else
      indexPath.row == @data.length
    end
  end


  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    return 416 if @data.length == 0
    return 40  if is_loadmore_cell? indexPath
    return 200 if indexPath.row == 0 && @config[:top_cell]
    return twitter_cell_height(indexPath) if @config[:twitter_cell]

    if @config.blank? || @config[:row_height].nil?
      80
    elsif @config[:row_height] == 0
      get_row_height(indexPath)
    else
      config[:row_height]
    end
  end

  # 获得动态内容高度
  def get_row_height(indexPath)
    dependent = @config[:row_dependent]

    return 80 if warn('没有设置动态行信息', dependent.nil? || dependent[:data].nil?)

    data = row_data(indexPath)
    str  = data[dependent[:data]]

    # 动态内容，默认宽度300，字体16
    width = 300
    size  = 16
    @layout.each do |layout|
      if layout[:data] == dependent[:data]
        width = layout[:frame].split(",")[2].to_i
        size  = layout[:size]
      end
    end

    # 基准高度
    base = dependent[:base] || 0
    get_content_height(str, width, size) + base
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    return if @data.length == 0
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
  end

  def loadMore
    @params[:page] += 1
    @loading = true
    load_data
  end

  def show_more?(count)
    # 若配置不分页，直接返回false
    return false if @config[:page] == false || count == 0
    @per_page = @config[:per_page] || @per_page
    count < @per_page * @params[:page] ? false : true
  end

  # 上拉自动加载下一页
  def tableView(tableview, willDisplayCell:cell, forRowAtIndexPath:indexPath)
    if !@loading && show_more?(@data.length) && (indexPath.row + 3 > @data.length)
      loadMore
    end
  end

  def scrollViewDidEndDecelerating(scrollView)
    if @config[:top_cell]
     @page_control.currentPage = (scrollView.contentOffset.x/320).ceil
    end
  end

  def top_cell
    if @config[:top_cell]
      top_story_cell(@top_data)
    else
      empty_cell
    end
  end

  def twitter_cell(data)
    cell = empty_cell

    content_x  = 45
    content_y  = 25
    width = 270
    size  = 15

    # 头像 user_photo_url
    user_photo = image(data[:user_photo_url], [[5,5],[32,32]], 'photo')
     # 'user', data[:user_id])
    
    # 名字 user_name
    user_name  = button(data[:user_name], [[content_x,5],[90,15]], 14, '#1D92B5', 'user', data[:user_id], 'left')

    # 照片 photo_url
    photo      = nil
    if data[:photo_url].length > 0 
      content_y   = 275  
      photo       = image(data[:photo_url], [[content_x, 30], [240, 240]], 'photo')
    end

    # 文字 content
    content_label = context(data[:content], [[content_x, content_y],[width,100]], 15, '#000000', false)

    info_y  = content_y + get_content_height(data[:content], width, size)

    time_label      = label(data[:time], [[content_x, info_y], [80, 20]], 13, false, 'gray', nil, false, nil, 'left')

    comment_icon    = image('comment_icon', [[content_x + 70, info_y + 5], [15, 13]], 'photo') 
    comment_count   = label(data[:comment_count], [[content_x + 88, info_y +1], [80, 20]], 13, false, 'gray', nil, false, nil, 'left')

    array  = [user_photo, user_name, photo, content_label, time_label, comment_icon, comment_count]

    # comment_label  = label(data[:time], [[content_x, comment_y], [80, 20]], 13, false, 'gray', nil, false, nil, 'left')
    # base_height = data[:photo_url].length > 0 ? 280 : 30
    # y = get_content_height(data[:content], 270, 15) + base_height

    # like_btn  = button('赞', [[42,y],[90,15]], 14, '#1D92B5', 'user', data[:user_id], 'left')
    add_subviews(cell, array)

    cell
  end

  def twitter_cell_height(indexPath)
    data = row_data(indexPath)
    str  = data[:content]

    width = 270
    size  = 15
    # 基准高度
    # base_height = data[:photo_url].length > 0 ? 280 : 30
    base_height = data[:photo_url].length > 0 ? 300 : 50
    get_content_height(str, width, size) + base_height
  end



  # 是否允许删除
  def tableView(tableView, canEditRowAtIndexPath:indexPath)
    @config[:delete] == true
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    new_data = []
    0.upto(@data.length-1) { |i| new_data << @data[i] if i != indexPath.row }
    @data = new_data
    @table_view.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
  end
end
