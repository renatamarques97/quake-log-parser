RSpec.describe Player do
  describe "initialize" do
    let(:id) { 1 }
    let(:name) {'renata'}

    subject { described_class.new(id, name) }

    it "valid parameters" do
      expect(subject.id).to eq(id)
      expect(subject.name).to eq(name)
    end
  end
end
