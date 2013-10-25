class Account
  attr_accessor :id, :name, :mobile, :email, :sex, :company, :job, :like_count,
                :photo

  def initialize(json={})
    @id       = json[:id]
    @name     = json[:name]
    @email    = json[:email]
    @sex      = json[:sex]
    @company  = json[:company]
    @job      = json[:job]
    @liek_count   = json[:like_count]

  end

end
