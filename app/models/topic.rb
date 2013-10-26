class Topic
  attr_accessor :id, :title, :created_at, :updated_at, :replied_at, :replied_count, 
                :node_name, :node_id, :last_reply_user_id, :last_reply_user_login, 
                :user, :body, :body_html, :replies, :hits

  def initialize(json={})
    @id         = json[:id]
    @title      = json[:title]
    @created_at = json[:created_at]
    @replied_count = json[:replied_count]
    @body       = json[:body]
    @body_html  = json[:body_html]
    @user       = User.new(json[:user])
    @created_at = json[:created_at][0,19].to_s.to_date
    @updated_at = json[:updated_at][0,19].to_s.to_date
    @replied_at = json[:replied_at].nil? ? nil : json[:replied_at][0,19].to_s.to_date
    # [0,19].to_date
    @replies    = json[:replies].nil? ? [] : json[:replies].map{|r| r = Reply.new(r) } 
    @hits       = json[:hits]
  end

end
