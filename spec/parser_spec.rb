RSpec.describe Parser::QuakeParser do

  describe "file" do
    let!(:path) { ("parser.log") }

    subject { described_class.new }
    
    context "valid output" do
      it "#from_file" do
        expect(subject.from_file(path)).to be nil
      end
    end

    it "#games_summary" do
      expect(subject.games_summary).not_to be nil
    end

    it "#games_summary" do
      expect(subject.games_summary).to eq([])
    end

    it "#reset_status" do
      expect(subject.reset_status).to be nil
    end

  end
  
  
  describe "processes" do
    let!(:item_line) { ("21:18 Item: 2 weapon_rocketlauncher\n") }
    let!(:line) { ("20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT") }
    let!(:player_change) { ('20:37 ClientUserinfoChanged: 2') }
    let!(:game) { Game.new }
    let!(:item) { Item.new("weapon_rocketlauncher", "2118", "2") }

    subject { described_class.new }

    context "valid output" do

      it "#process_line" do
        subject.process_new_game

        expect(subject.process_line(line)).to eq([])
      end
      
      it "#process_new_game current_game" do
        expect(subject.process_new_game).to include(subject.current_game)
      end
      it "#process_new_game count" do
        expect(subject.process_new_game.count).to eq(1)
      end
      
      # it "#process_player_change" do
      #   subject.process_new_game

      #   expect(subject.process_player_change(player_change)).to eq([])
      # end
      
      it "#process_new_item" do
        subject.process_new_game
        subject.process_new_item(item_line)

        # expect(subject.process_new_item(item_line)).to include(item)

        expect(subject.current_game.items.first.name).to eq("weapon_rocketlauncher")
        expect(subject.current_game.items.first.owner_id).to eq("2")
        expect(subject.current_game.items.first.collected_at).to eq(2118)
      end
      
      # it "#process_new_kill" do
        # subject.process_new_game

      #   expect(subject.process_new_kill(line)).to eq([])
      # end

    end
  end

end
