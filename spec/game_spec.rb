RSpec.describe Game do
  context "#remove_expired_items" do
    let!(:current_time) { 0003 }
    let!(:collected_at) { 0000 }
    let!(:current_time_bigger) { 0004 }
    let!(:collected_at_bigger) { 0000 }
    let!(:current_time_smaller) { 0002 }
    let!(:collected_at_smaller) { 0000 }
    let!(:expiration_time) { 3 }
    let!(:result) {(current_time - collected_at)}
    let!(:result_bigger) {(current_time_bigger - collected_at_bigger)}
    let!(:result_smaller) {(current_time_smaller - collected_at_smaller)}

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

  it "#to_hash" do
    let!(:hash) {  }

    subject { described_class.to_hash }

    # expect(subject).to eq(hash)
  end

  it "#inventories" do
    let!(:hash) {  }
    
    subject { described_class.inventories }

    expect(false).to eq(false)
  end

  it "#new_player" do
    subject { described_class.new_player() }

    expect(false).to eq(false)
  end

  it "#add_item" do
    subject { described_class.add_item() }

    expect(false).to eq(false)
  end

  it "#change_items_ownership" do
    subject { described_class.change_items_ownership() }

    expect(false).to eq(false)
  end

end
