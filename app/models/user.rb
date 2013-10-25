class User
  attr_accessor :id, :name, :login, :location, :company, :twitter, :website, :bio,
  				:github_url, :email, :gravatar_hash, :avatar_url

  def initialize(json={})
    @id       = json[:id]
    @title    = json[:name]
    @login	  = json[:login]

  end

end
