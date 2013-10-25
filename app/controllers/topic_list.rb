# -*- encoding : utf-8 -*-
class TopicList < PM::Screen
  include ChaComponent
  include Common

  CELL_HEIGHT = 80

  def loadView
    super

    @page     = 1
    @loading  = false
    @list_url = "topics.json"
    @params   = {}
    @data     = []
    view << @main  = full_view
    # @main << nav_bar('title-company', 'search', 'search')
    init_table_view
  end

  def search 
    p 'search'
  end

  def viewDidLoad
    super
    self.title  = "主题"

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
    height ||= view.bounds.size.height - 45

    @table_view                  = UITableView.plain
    @table_view.delegate         = self
    @table_view.dataSource       = self
    @table_view.frame            = [[0, 45], [width, height]]
    @table_view.autoresizingMask = UIViewAutoresizingFlexibleHeight

    bg                = UIImageView.new
    bg.image          = 'bg'.uiimage

    @table_view.backgroundView   = bg
         
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
      cell << label(topic.title, '10,10,300,15', 15)
      
      # cell.selectionStyle = UITableViewCellSelectionStyleNone
      # cell.accessoryType  = UITableViewCellAccessoryNone

      cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    # push Company.new
  end

  def tableView(tableView, numberOfRowsInSection:section)
    # return 10
    return 1 if @data.length == 0
    count = @data.length
    # count += 1 if show_more?(count)
    count
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    CELL_HEIGHT
  end

  def viewWillDisappear(animated)
    super
    SVProgressHUD.dismiss
  end 



end