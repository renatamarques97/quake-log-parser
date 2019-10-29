RSpec.describe Parser::Rules do
  describe "#new_game?" do
    let(:new_game) {'0:00 InitGame: \sv_floodProtect\1\sv_maxPing\0\sv_minPing\0\sv_maxRate\10000\sv_minRate\0\sv_hostname\Code Miner Server\g_gametype\0\sv_privateClients\2\sv_maxclients\16\sv_allowDownload\0\dmflags\0\fraglimit\20\timelimit\15\g_maxGameClients\0\capturelimit\8\version\ioq3 1.36 linux-x86_64 Apr 12 2009\protocol\68\mapname\q3dm17\gamename\baseq3\g_needpass\0'}

    context "" do
      it "" do
        expect(described_class.new_game?(new_game)).to be(true)
      end
    end
  end

  describe "#current_time" do

  end

  describe "#new_player?" do

  end

  describe "#player_id" do

  end

  describe "#player_change?" do

  end

  describe "#player_change_info" do

  end

  describe "#new_item?" do

  end

  describe "#new_item_info" do

  end

  describe "#new_kill?" do

  end

  describe "#new_kill_info" do

  end

  describe "#killed_by_world?" do

  end
end
