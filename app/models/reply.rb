class Reply
  attr_accessor :id, :body, :body_html, :created_at, :updated_at, :user

  def initialize(json={})
    @id       = json[:id]
    @body     = json[:body]
    @body_html= json[:body_html]
    @user     = User.new(json[:user])
    @created_at = json[:created_at][0,19].to_s.to_date
    # .to_date
    @updated_at = json[:updated_at][0,19].to_s.to_date
  end

end
