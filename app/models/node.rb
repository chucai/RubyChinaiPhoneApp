class Node
  attr_accessor :id, :name, :topics_count, :summary, :section_id, :sort, :section_name

  def initialize(json={})
    @id       = json[:id]
    @name     = json[:name]
    @topics_count   = json[:topics_count]
    @summary        = json[:summary]
    @section_id     = json[:section_id]
    @sort           = json[:sort]
    @section_name   = json[:section_name]
    
  end

end
