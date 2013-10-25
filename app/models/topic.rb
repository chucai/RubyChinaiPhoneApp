class Topic
  attr_accessor :id, :title, :created_at, :updated_at, :replied_at, :replied_count, 
                :node_name, :node_id, :last_reply_user_id, :last_reply_user_login, 
                :user

  def initialize(json={})
    @id       = json[:id]
    @title    = json[:title]
  end

end
