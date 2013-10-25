class User
  attr_accessor :id, :name, :login, :location, :company, :twitter, :website, :bio,
  				:github_url, :email, :gravatar_hash, :avatar_url

  def initialize(json={})
    @id       = json[:id]
    @name     = json[:name]
    @login	  = json[:login]
    @avatar_url  = json[:avatar_url].to_s
    @company  = json[:company]
    @location = json[:location].to_s
    @body     = json[:body]

    
  end

end
