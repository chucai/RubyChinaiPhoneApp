class Site
  attr_accessor :id, :name, :desc, :favicon, :created_at, :url

  def initialize(json={})
    @id       = json[:id]
    @name     = json[:name]
    @desc     = json[:desc]
    @url      = json[]
    @favicon  = json[:favicon]
    @created_at = json[:created_at]

    
  end

end
