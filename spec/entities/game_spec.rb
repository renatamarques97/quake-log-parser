RSpec.describe Game do
  describe "#remove_expired_items" do
    let(:current_time) { 10 }
    let(:expired_item) { Item.new("Expired", "00:07", "1") }
    let(:valid_item) { Item.new("Valid", "00:08", "1") }

    before do
      subject.items = [expired_item, valid_item]
      subject.remove_expired_items(current_time)
    end

    it "removes the expired items" do
      expect(subject.items).not_to include(expired_item)
    end

    it "keeps all valid items" do
      expect(subject.items).to contain_exactly(valid_item)
    end
  end

  describe "#to_hash" do
    let(:expected_hash) do
      {
        players: [
          {
            id: player.id,
            name: player.name,
            inventory: {
              "Knife" => 1
            }
          }
        ]
      }
    end
    let(:player) { Player.new("1", "Renata") }
    let(:item) { Item.new("Knife", "00:00", player.id) }

    before do
      subject.add_player(player)
      subject.add_item(item)
    end

    it "returns the correct game hash" do
      expect(subject.to_hash).to eq(expected_hash)
    end
  end

  describe "#inventories" do
    let(:player) { Player.new("1") }
    let(:item) { Item.new("Knife", "00:00", player.id) }
    let(:expected_inventories_hash) do
      {
        player.id => {
          item.name => 1
        }
      }
    end

    before do
      subject.add_player(player)
      subject.add_item(item)
    end

    it "returns the expected inventories hash" do
      expect(subject.inventories).to eq(expected_inventories_hash)
    end
  end

  describe "#add_player" do
    let(:player) { Player.new("1") }

    it "adds a new player to the game" do
      expect {
        subject.add_player(player)
      }.to change {
        subject.players
      }.from({}).to({ player.id => player })
    end
  end

  describe "#add_item" do
    let(:item) { Item.new("Knife", "00:00", "1") }

    it "adds a new item to the game" do
      expect {
        subject.add_item(item)
      }.to change {
        subject.items
      }.from([]).to([item])
    end
  end

  describe "#change_items_ownership" do
    context "when player is killed by another player" do
      let(:killed) { Player.new("1", "Killed") }
      let(:killer) { Player.new("2", "Killer") }

      let(:item) { Item.new("Knife", "00:00", killed.id) }

      before do
        subject.add_player(killed)
        subject.add_player(killer)
        subject.add_item(item)
      end

      it "changes item ownership" do
        expect {
          subject.change_items_ownership(killed.id, killer.id)
        }.to change {
          subject.items.first.owner_id
        }.from(killed.id).to(killer.id)
      end
    end

    context "when player is killed by world" do
      let(:killed) { Player.new("1", "Killed") }

      let(:item) { Item.new("Knife", "00:00", killed.id) }

      before do
        subject.add_player(killed)
        subject.add_item(item)
      end

      it "changes item ownership" do
        expect {
          subject.change_items_ownership(killed.id, "1022", true)
        }.to change {
          subject.items.count
        }.from(1).to(0)
      end
    end

    context "when player commits suicide" do
      let(:killed) { Player.new("1", "Killed") }

      let(:item) { Item.new("Knife", "00:00", killed.id) }

      before do
        subject.add_player(killed)
        subject.add_item(item)
      end

      it "changes item ownership" do
        expect {
          subject.change_items_ownership(killed.id, killed.id)
        }.to change {
          subject.items.count
        }.from(1).to(0)
      end
    end
  end
end
