RSpec.describe Parser::Rules do
  describe ".new_game?" do
    let(:new_game) {'0:00 InitGame: \sv_floodProtect\1\sv_maxPing\0\sv_minPing\0\sv_maxRate\10000\sv_minRate\0\sv_hostname\Code Miner Server\g_gametype\0\sv_privateClients\2\sv_maxclients\16\sv_allowDownload\0\dmflags\0\fraglimit\20\timelimit\15\g_maxGameClients\0\capturelimit\8\version\ioq3 1.36 linux-x86_64 Apr 12 2009\protocol\68\mapname\q3dm17\gamename\baseq3\g_needpass\0'}

    it "" do
      expect(described_class.new_game?(new_game)).to be(true)
    end
  end

  describe ".current_time" do
    let(:current_time) {'00:00 '}

    context "" do
      it "current time transformed for integer" do
        expect(described_class.current_time(current_time)).to be(0)
      end
    end
  end

  describe ".new_player?" do
    let(:new_player) {" ClientConnect: 2\n"}

    it "" do
      expect(described_class.new_player?(new_player)).to be(true)
    end
  end

  describe ".player_id" do
    let(:player_id) {" ClientConnect: 2\n"}

    it "" do
      expect(described_class.player_id(player_id)).to eq("2")
    end
  end

  describe ".player_change?" do
    let(:player_change) {'20:38 ClientUserinfoChanged: 2 n\Isgalamido\t\0\model\uriel/zael\hmodel\uriel/zael\g_redteam\\g_blueteam\\c1\5\c2\5\hc\100\w\0\l\0\tt\0\tl\0'}

    it "" do
      expect(described_class.player_change?(player_change)).to be(true)
    end
  end

  describe ".player_change_info" do
    let(:player_change_info) {'20:38 ClientUserinfoChanged: 2 n\Isgalamido\t\0\model\uriel/zael\hmodel\uriel/zael\g_redteam\\g_blueteam\\c1\5\c2\5\hc\100\w\0\l\0\tt\0\tl\0'}
    let(:expected) do
      {
        player_id: "2",
        player_name: "Isgalamido"
      }
    end

    subject { described_class.player_change_info(player_change_info) }

    it "" do
      expect(subject[:id]).to eq(expected[:player_id])
    end

    it "" do
      expect(subject[:name]).to eq(expected[:player_name])
    end
  end

  describe ".new_item?" do
    let(:new_item) {"20:40 Item: 2 ammo_rockets\n"}

    it "" do
      expect(described_class.new_item?(new_item)).to be(true)
    end
  end

  describe ".new_item_info" do
    let(:new_item_info) {"22:11 Item: 2 item_quad\n"}
    let(:expected) do
      {
        item_quad: "2"
      }

      it "" do
        expect(described_class.new_item_info(new_item_info)).to eq(expected)
      end
    end
  end

  describe ".new_kill?" do
    let(:new_kill) {'2:37 Kill: 3 2 10: Isgalamido killed Dono da Bola by MOD_RAILGUN'}

    it "" do
      expect(described_class.new_kill?(new_kill)).to be(true)
    end
  end

  describe ".new_kill_info" do
    let(:new_kill_line) {'22:06 Kill: 2 3 7: Isgalamido killed Mocinha by MOD_ROCKET_SPLASH'}
    let(:expected) do
      {
        killer_id: "2",
        killed_id: "3"
      }
    end

    subject { described_class.new_kill_info(new_kill_line) }

    it "returns the expected killer id" do
      expect(subject[:killer_id]).to eq(expected[:killer_id])
    end

    it "returns the expected killed id" do
      expect(subject[:killed_id]).to eq(expected[:killed_id])
    end
  end

  describe ".killed_by_world?" do
    let(:killed_by_world) {'23:06 Kill: 1022 2 22: <world> killed Isgalamido by MOD_TRIGGER_HURT'}

    it "" do
      expect(described_class.killed_by_world?(killed_by_world)).to be(true)
    end
  end

end
