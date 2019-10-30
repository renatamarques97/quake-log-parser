RSpec.describe Item do
  describe "initialize" do
    let(:name) {'renata'}
    let(:collected_at) {'2118'}
    let(:owner_id) {'2'}

    subject { described_class.new(name, collected_at, owner_id) }

    it "valid parameters" do
      expect(subject.name).to eq(name)
      expect(subject.collected_at).to eq(collected_at.to_i)
      expect(subject.owner_id).to eq(owner_id)
    end
  end
end
