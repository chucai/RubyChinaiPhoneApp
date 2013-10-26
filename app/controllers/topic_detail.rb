# -*- encoding : utf-8 -*-
class TopicDetail < PM::Screen
  include ChaComponent
  include Common

  attr_accessor :id

  def initWithID(id)
    if initWithNibName(nil, bundle:nil)
      @id = id
    end
    self
  end

  def init
    super
    self
  end

  def loadView
    super

    @page     = 1
    @loading  = false
    @list_url = "topics/#{@id}.json"
    @params   = {}
    @data     = []
    view << @main  = full_view
    # @main << nav_bar('title-company', 'search', 'search')
    init_table_view

    navigationItem.rightBarButtonItem      = bar_item("分享", 'share')
    
  end
  

  def viewDidLoad
    super
    self.title  = "主题详情"

    @client   = Http.new

    @data = []
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
        warn(json)
        @topic = Topic.new(json)
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

    view << @table_view
    # @table_view.addPullToRefreshWithActionHandler -> { reload_data } if @list_url

  end  

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    # 空Cell
    if indexPath.row == 0
      topic_cell
    else
      reply_cell(indexPath.row-1)
    end
  end

  def topic_cell
      cell = empty_cell
      cell << label(@topic.title, '10,10,300,15', 15)
      cell << image(@topic.user.avatar_url, '10,30,20,20')
      cell << label(@topic.user.login, '40,30,100,15', 14, false, '#CCCCCC')
      html = "<html><body>#{@topic.body_html}</body></html>"
      cell << web('', '0,60,320,300', html)
      # height = get_content_height(@topic.body, 300, 14)
      # cell << context(@topic.body, "10,60,300,#{height}", 14)
      cell.selectionStyle = UITableViewCellSelectionStyleNone
      cell.accessoryType  = UITableViewCellAccessoryNone

      cell
  end

  def reply_cell(index)
      reply = @topic.replies[index]
      user  = reply.user

      cell = empty_cell
      cell << image(user.avatar_url,  '10,10,20,20')
      cell << label(user.login,       '40,10,100,15', 14, false, '#333333')
      cell << label(friendly_time(reply.created_at), '-10,10,100,13', 13, false, '#CCCCCC', :right)
      height = height = get_content_height(reply.body, 270, 14)
      cell << context(reply.body,       "40,30,270,#{height}", 14)
  
      cell.selectionStyle = UITableViewCellSelectionStyleNone
      cell.accessoryType  = UITableViewCellAccessoryNone

      cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    # push Company.new
  end

  def tableView(tableView, numberOfRowsInSection:section)
    # return 10
    return 0 if @topic.nil?
    return @topic.replies.length + 1
    count = @data.length
    # count += 1 if show_more?(count)
    count
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    if indexPath.row == 0
      370
      # get_content_height(@topic.body, 300, 14) + 80
    else
      reply = @topic.replies[indexPath.row-1]
      get_content_height(reply.body, 270, 14) + 40
    end
  end

  def viewWillDisappear(animated)
    super
    SVProgressHUD.dismiss
  end 

  def share
    text = "#{@topic.title} http://ruby-china.org/topics/#{@topic.id}"
    share_to_sns(text)  
  end

end