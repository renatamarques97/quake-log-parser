RSpec.describe Parser::QuakeParser do
  let(:path) { "parser.log" }

  describe "#from_file" do
    it "valid output" do
      expect {
        subject.from_file(path)
      }.to change {
        subject.current_game
      }
    end
  end

  describe "#games_summary" do
    context "when games are empty" do
      let(:expected_summary) { [] }

      it "returns the correct summary" do
        expect(subject.games_summary).to eq(expected_summary)
      end
    end

    context "when there are games" do
      let(:file_path) { "spec/support/sample.log" }
      let(:expected_summary) do
        [
          {
            players: [
              { id: "2", inventory: nil, name: "Isgalamido"}
            ]
          },
          {
            players: [
              {
                id: "2",
                inventory: {
                  "ammo_rockets" => 1,
                  "item_armor_body" => 1,
                  "weapon_rocketlauncher" => 1
                },
                name: "Isgalamido"
              }
            ]
          }
        ]
      end

      before do
        subject.from_file(file_path)
      end

      it "returns the correct summary" do
        expect(subject.games_summary).to eq(expected_summary)
      end
    end
  end

  describe "#reset_status" do
    before do
      subject.process_new_game
    end

    it "clears the current game" do
      expect {
        subject.reset_status
      }.to change {
        subject.current_game
      }.to(nil)
    end

    it "sets the games to an empty array" do
      expect {
        subject.reset_status
      }.to change {
        subject.games
      }.to([])
    end
  end

  describe "processes" do
    describe "#process_line" do
      context "when new game" do
        let(:new_game_line) { "0:00 InitGame: \s" }

        it "calls #process_new_game" do
          expect(subject).to receive(:process_new_game)
          subject.process_line(new_game_line )
        end
      end

      context "when new player" do
        let(:new_player_line) { "20:34 ClientConnect: 2\n" }

        it "calls #process_new_player" do
          expect(subject).to receive(:process_new_player).with(new_player_line)
          subject.process_line(new_player_line)
        end
      end

      context "when player change" do
        let(:new_player_line) { "20:34 ClientConnect: 2\n" }
        let(:player_change_line) { "20:38 ClientUserinfoChanged: 2 n\\Isgalamido\\t\\" }

        before do
          subject.process_new_game
          subject.process_new_player(new_player_line)
        end

        it "calls #process_player_change" do
          expect(subject).to receive(:process_player_change).with(player_change_line)
          subject.process_line(player_change_line)
        end
      end

      context "when new item" do
        let(:item_line) { "20:40 Item: 2 weapon_rocketlauncher\n" }

        before do
          subject.process_new_game
        end

        it "calls #process_new_item" do
          expect(subject).to receive(:process_new_item).with(item_line)
          subject.process_line(item_line)
        end
      end

      context "when new kill" do
        let(:new_kill_line) { "20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT" }

        before do
          subject.process_new_game
        end

        it "calls #process_new_kill" do
          expect(subject).to receive(:process_new_kill).with(new_kill_line)
          subject.process_line(new_kill_line)
        end
      end

      context "items expiration" do
        let(:new_kill_line) { "20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT" }

        before do
          subject.process_new_game
        end

        it "calls current_game#remove_expired_items" do
          expect(subject.current_game).to receive(:remove_expired_items).with(2054)
          subject.process_line(new_kill_line)
        end
      end
    end

    describe "#process_new_game" do
      it "returns the expected game" do
        expect(subject.process_new_game).to include(subject.current_game)
      end

      it "returns the expected count" do
        expect(subject.process_new_game.count).to eq(1)
      end
    end

    context "player processing" do
      let(:player_change) { "20:38 ClientUserinfoChanged: 2 n\\Name\\t" }
      let(:new_player) { "20:38 ClientConnect: 2\n" }

      before do
        subject.process_new_game
        subject.process_new_player(new_player)
      end

      describe "#process_new_player" do
        let(:player) { subject.current_game.players.values.first }

        it "creates a new player with the correct id" do
          expect(player.id).to eq("2")
        end

        it "creates a new player with the correct name" do
          expect(player.name).to be_nil
        end
      end

      describe "#process_player_change" do
        before do
          subject.process_player_change(player_change)
        end

        let(:player) { subject.current_game.players.values.first }

        it "returns the expected result" do
          expect(player.name).to eq("Name")
        end
      end
    end

    describe "#process_new_item" do
      let(:item_line) { ("21:18 Item: 2 weapon_rocketlauncher\n") }

      before do
        subject.process_new_game
        subject.process_new_item(item_line)
      end

      let(:item) {subject.current_game.items.first }

      it "returns the correct item name" do
        expect(item.name).to eq("weapon_rocketlauncher")
      end

      it "returns the correct owner id" do
        expect(item.owner_id).to eq("2")
      end

      it "returns the correct collected at" do
        expect(item.collected_at).to eq(2118)
      end

      it "returns the correct count item" do
        expect(subject.current_game.items.count).to eq(1)
      end
    end

    describe "#process_new_kill" do
      let(:item_line) { ("21:18 Item: 2 weapon_rocketlauncher\n") }

      before do
        subject.process_new_game
        subject.process_new_item(item_line)
      end

      context "when player is killed by the world" do
        let(:kill_line) { ("20:54 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT") }

        it "deletes the item" do
          expect {
            subject.process_new_kill(kill_line)
          }.to change {
            subject.current_game.items
          }.to([])
        end
      end

      context "when player is killed by another player" do
        let(:kill_line) { ("20:54 Kill: 4 2 22: Renata killed Isgalamido by MOD_TRIGGER_HURT") }

        it "changes item ownership" do
          expect {
            subject.process_new_kill(kill_line)
          }.to change {
            subject.current_game.items.first.owner_id
          }.to("4")
        end
      end

      context "when player commits suicide" do
        let(:kill_line) { ("20:54 Kill: 2 2 22: Isgalamido killed Isgalamido by MOD_TRIGGER_HURT") }

        it "deletes the item" do
          expect {
            subject.process_new_kill(kill_line)
          }.to change {
            subject.current_game.items
          }.to([])
        end
      end
    end
  end
end
