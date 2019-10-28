class Item
  attr_accessor :name, :collected_at, :owner_id

  def initialize(name, collected_at, owner_id)
    @name = name
    @collected_at = collected_at.gsub(/\D+/, "").to_i
    @owner_id = owner_id
  end
end
