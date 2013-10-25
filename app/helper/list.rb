module List
  def init 
    @page     = 1
    @loading  = false
    @list_url = "/company/chacha/users"
    @params   = {}
    @data     = []
    @cell_height = 100
  end

  def loadView
    super
    init_table_view
  end

  def viewDidLoad
    super
    @client   = Http.new
    load_data
  end

  def load_data
    progress("正在加载")  if @page == 1

    @client.get(@list_url, @params) do |json|
      # warn('get_data')
      if json.nil?
        App.alert('网络连接不正常，请调整网络后重新尝试')
      else
        @data = json
        @table_view.reloadData
      end
      SVProgressHUD.dismiss
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
    # @table_view.backgroundColor  = @background_color.uicolor if @background_color
    # @table_view.separatorStyle   = UITableViewCellSeparatorStyleNone
    @table_view.addPullToRefreshWithActionHandler -> { reload_data }
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
      cell = custom_cell(@data[indexPath.row])
      cell
    end
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    select(@data[indexPath.row])
  end

  def tableView(tableView, numberOfRowsInSection:section)
    return 1 if @data.length == 0
    count = @data.length
    # count += 1 if show_more?(count)
    count
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    @cell_height
  end

  def viewWillDisappear(animated)
    super
    SVProgressHUD.dismiss
  end 

  def progress(text)
    SVProgressHUD.showWithStatus(text)
  end
end