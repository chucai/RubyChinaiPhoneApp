# -*- encoding : utf-8 -*-
class TopicList < PM::Screen
  include ChaComponent
  include Common

  CELL_HEIGHT = 50


  def initWithNodeId(id)
    if initWithNibName(nil, bundle:nil)
      @node_id = id
    end
    self
  end

  # def initWithUser(login)
  #   if initWithNibName(nil, bundle:nil)
  #     @user = login
  #   end
  #   self
  # end

  def url
    if @user
      "users/#{@user}/topics.json"
    elsif @node_id
      "topics/node/#{@node_id}.json"
    else
      "topics.json"
    end
  end

  def loadView
    super

    @page     = 1
    @loading  = false
    @list_url = url

    @params   = {}
    @data     = []
    view << @main  = full_view
    
    navigationItem.leftBarButtonItem      = bar_item("菜单", 'menu')
    
    init_table_view
  end

  def search 
    p 'search'
  end

  def viewDidLoad
    super

    self.title  = @user ? "#{@user}的主题" : "主题"

    @client   = Http.new

    load_data
  end


  def load_data
    # return
    msg("正在加载")  if @page == 1

    @client.get(@list_url, @params) do |json|
      # warn('get_data')
      if json.nil?
        App.alert('网络连接不正常，请调整网络后重新尝试')
      else
        @data = json
        @table_view.reloadData
      end
      hide_msg
    end 
  end

  def reload_data
    @params = {:page => 1}
    load_data
    @table_view.pullToRefreshView.stopAnimating
  end

  def load_more
    @page     += 1
    @loading  = true
    load_data
  end

  def init_table_view
    
    width  ||= view.bounds.size.width
    height ||= view.bounds.size.height

    @table_view                  = UITableView.plain
    @table_view.delegate         = self
    @table_view.dataSource       = self
    @table_view.frame            = [[0, 0], [width, height]]
    @table_view.autoresizingMask = UIViewAutoresizingFlexibleHeight
         
    # @table_view.separatorStyle   = UITableViewCellSeparatorStyleNone
    @table_view.addPullToRefreshWithActionHandler -> { reload_data }
    @table_view.tableFooterView  = footer
    # @table_view.pullToRefreshView.setTitle(Config::REFRESH_TITLE, forState:SVPullToRefreshStateLoading)

    # @table_view.pullToRefreshView.arrowColor = '#FF9900'.uicolor

    view << @table_view
    # @table_view.addPullToRefreshWithActionHandler -> { reload_data } if @list_url

  end  

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    # 空Cell
    if @data.length == 0
      empty_cell
      # nodata_cell  # 没有内容
    # elsif is_loadmore_cell? indexPath
    #   loading_cell # 加载更多Cell
    else
      # 一般cell
      custom_cell(indexPath)
    end
  end

  def custom_cell(indexPath)
      topic = Topic.new(@data[indexPath.row])
      
      cell = empty_cell
      height = get_content_height(topic.title, 300, 15)
      cell << context(topic.title, "10,10,300,#{height}", 15)
      cell << image(topic.user.avatar_url, "10,#{13+height},15,15")
      cell << label(topic.user.login, "36,#{13+height},100,15", 14, false, '#222222')
      cell << label(friendly_time(topic.created_at), "-10,#{13+height},80,13", 13, false, '#CCCCCC', :right)
      # cell.selectionStyle = UITableViewCellSelectionStyleNone
      # cell.accessoryType  = UITableViewCellAccessoryNone

      cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    topic = Topic.new(@data[indexPath.row])
    push TopicDetail.alloc.initWithID(topic.id)
  end

  def tableView(tableView, numberOfRowsInSection:section)
    # return 10
    return 0 if @data.length == 0
    count = @data.length
    # count += 1 if show_more?(count)
    count
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    # p @data[indexPath.row]
    # return 0 if @data.nil?
    topic   = Topic.new(@data[indexPath.row])
    height  = get_content_height(topic.title, 300, 15)
    CELL_HEIGHT + height - 15
  end

  def viewWillDisappear(animated)
    super
    SVProgressHUD.dismiss
  end 

  def menu
    App.delegate.slide_menu.show_menu
  end


end