class Game
  ITEM_EXPIRATION_IN_MINUTES = 3

  attr_accessor :id, :items, :players

  def initialize
    @players = {}
    @items = []
  end

  def remove_expired_items(current_time)
    @items.delete_if { |item| current_time - item.collected_at >= ITEM_EXPIRATION_IN_MINUTES }
  end

  def to_hash
    {
      players: players.map do |id, player|
        {
          id: id,
          name: player.name,
          inventory: inventories[id]
        }
      end
    }
  end

  def inventories
    @_inventories = items.group_by { |item| item.owner_id }
      .map do |owner_id, items|
        inventory = items.reduce({}) do |hash, item|
          hash[item.name] ? hash[item.name] += 1 : hash[item.name] = 1
          hash
        end
        [owner_id, inventory]
    end.to_h
  end

  def new_player(player)
    return player if players[player.id]

    players[player.id] = player
  end

  def add_item(item)
    @items << item
  end

  def change_items_ownership(current_owner_id, new_owner_id, killed_by_world = false)
    return items.delete_if { |item| item.owner_id == current_owner_id } if killed_by_world

    items.each do |item|
      next if item.owner_id != current_owner_id

      if new_owner_id == current_owner_id
        items.delete(item)
      else
       item.owner_id = new_owner_id
      end
    end
  end
end
