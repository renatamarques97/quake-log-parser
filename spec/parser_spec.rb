RSpec.describe Parser::QuakeParser do

  describe "file" do
    let!(:path) { ("parser.log") }

    subject { described_class.new }

    context "#from_file" do
      it "valid output" do
        expect {
          subject.from_file(path)
        }.to change {
          subject.current_game
        }
      end
    end

    context "#games_summary" do
      let(:expected_summary) { [] }

      it "valid output" do
        expect(subject.games_summary).not_to be nil
      end
      it "check return type" do
        expect(subject.games_summary).to eq(expected_summary)
      end
    end

    context "#reset_status" do
      it "valid output" do
        subject.process_new_game

        expect {
          subject.reset_status
        }.to change {
          subject.current_game
        }
      end

      it "check type" do
        subject.process_new_game

        expect {
          subject.reset_status
        }.to change {
          subject.games
        }.to([])
      end
    end
  end

  describe "processes" do
    let!(:item_line) { ("21:18 Item: 2 weapon_rocketlauncher\n") }
    let!(:line) { ("20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT") }
    let!(:player_change) { "20:38 ClientUserinfoChanged: 2 n\\Name\\t" }
    let!(:new_player) { "20:38 ClientConnect: 2\n" }
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

      it "#process_player_change" do
        subject.process_new_game
        subject.process_new_player(new_player)
        subject.process_player_change(player_change)

        player = subject.current_game.players["2"]

        expect(player.name).to eq("Name")
      end
    end

      context "#process_new_item" do
        before do
          subject.process_new_game
          subject.process_new_item(item_line)
        end

        it "returns the correct item name" do
          item = subject.current_game.items.first
          expect(item.name).to eq("weapon_rocketlauncher")
        end
        it "returns the correct owner id" do
          item = subject.current_game.items.first
          expect(item.owner_id).to eq("2")
        end
        it "returns the correct collected at" do
          item = subject.current_game.items.first
          expect(item.collected_at).to eq(2118)
        end
        it "returns the correct count item" do
          item = subject.current_game.items.first
          expect(subject.current_game.items.count).to eq(1)
        end
      end

      context "#process_new_kill" do
        let(:expected_new_kill) { [] }

        it "check the return type" do
          subject.process_new_game

          expect(subject.process_new_kill(line)).to eq(expected_new_kill)
        end
      end
  end

end
