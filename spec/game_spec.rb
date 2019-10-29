RSpec.describe Game do
  describe "#remove_expired_items" do
    let!(:current_time) { 3 }
    let!(:collected_at) { 0 }
    let!(:current_time_bigger) { 4 }
    let!(:collected_at_bigger) { 0 }
    let!(:current_time_smaller) { 2 }
    let!(:collected_at_smaller) { 0 }
    let!(:expiration_time) { 3 }
    let!(:result) {(current_time - collected_at)}
    let!(:result_bigger) {(current_time_bigger - collected_at_bigger)}
    let!(:result_smaller) {(current_time_smaller - collected_at_smaller)}

    context "values" do
      it "equal" do
        subject { described_class.remove_expired_items(current_time) }

        expect(result).to eq(expiration_time)
      end
      it "bigger" do
        subject { described_class.remove_expired_items(current_time) }

        expect(result_bigger).to be >(expiration_time)
      end
      it "smaller" do
        subject { described_class.remove_expired_items(current_time) }

        expect(result_smaller).to be <(expiration_time)
      end
    end
  end

  describe "hash" do
    context "#to_hash" do
      it "" do
        subject { described_class.new }

        expect(subject.to_hash).to eq({:players=>[]})
      end
    end
    context "#inventories" do 
      it "" do
        subject { described_class.new }

        expect(subject.inventories).to eq({})
      end
    end
  end

  context "#new_player" do
    let!(:player) { Player.new("1") }

    subject { described_class.new }
    it "#" do
      subject.new_player(player)
      expect(subject.players["1"]).to eq(player)
    end
  end

  context "#add_item" do
    let!(:item) { Item.new("gun", "309", "1") }

    subject { described_class.new }
    it "#" do
      subject.add_item(item)
      expect(subject.items).to contain_exactly(item)
    end
  end

  describe "#change_items_ownership" do
    context "" do
      it "killed" do
        subject { described_class.new }

        expect(subject.change_items_ownership("1","2")).to eq([])
      end

      it "killed by world" do
        subject { described_class.new }

        expect(subject.change_items_ownership("1","2", true)).to eq([])
      end

      it "killed by himself" do
        subject { described_class.new }

        expect(subject.change_items_ownership("1","1")).to eq([])
      end
    end
  end

end
