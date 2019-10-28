class Player
  attr_accessor :id, :name

  def initialize(id, name = nil)
    @id   = id
    @name = name
  end
end
