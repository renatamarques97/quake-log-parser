module Parser
  class Rules
    REGEX_LIST = {
      new_game: /(?:^|\W)InitGame(?:$|\W)/,
      all_non_digit: /\D+/,
      current_time: /(?<time>\d+:\d+)\s/,
      new_connection: /\sClientConnect\:\s(?<id>\d+)\n/,
      new_change: /\sClientUserinfoChanged:\s(?<id>\d+)\sn\\(?<name>(\w|\s)+)\\t/,
      new_item: /^(?<collected_at>\d+:\d+)\sItem:\s(?<owner_id>\d+)\s(?<name>\w+)\n/,
      new_kill: /\sKill:\s(?<killer_id>\d+)\s(?<killed_id>\d+)\s\d+:/,
      killed_by_world: /\sKill:\s1022/,
    }.freeze

    class << self
      def new_game?(line)
        line.match?(REGEX_LIST[:new_game])
      end

      def current_time(line)
        time = line.match(REGEX_LIST[:current_time])[:time]
        time.gsub(REGEX_LIST[:all_non_digit], "").to_i
      end

      def new_player?(line)
        line.match?(REGEX_LIST[:new_connection])
      end

      def player_id(line)
        line.match(REGEX_LIST[:new_connection])[:id]
      end

      def player_change?(line)
        line.match?(REGEX_LIST[:new_change])
      end

      def player_change_info(line)
        line.match(REGEX_LIST[:new_change])
      end

      def new_item?(line)
        line.match?(REGEX_LIST[:new_item])
      end

      def new_item_info(line)
        line.match(REGEX_LIST[:new_item])
      end

      def new_kill?(line)
        line.match?(REGEX_LIST[:new_kill])
      end

      def new_kill_info(line)
        line.match(REGEX_LIST[:new_kill])
      end

      def killed_by_world?(line)
        line.match?(REGEX_LIST[:killed_by_world])
      end
    end
  end
end
