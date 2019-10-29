require "parser/version"
require "entities/item"
require "entities/player"
require "entities/game"
require "parser/rules"

module Parser
  class Error < StandardError; end

  class QuakeParser
    attr_reader :games, :current_game

    def initialize
      @games = []
      @current_game = nil
    end

    def from_file(path)
      log = File.open(path)

      reset_status

      while line = log.gets
        process_line(line)
      end

      log.close
    end

    def games_summary
      games.map(&:to_hash)
    end

    def reset_status
      @games.clear
      @current_game = nil
    end

    def process_line(line)
      if Parser::Rules.new_game?(line)
        process_new_game
      elsif Parser::Rules.new_player?(line)
        process_new_player(line)
      elsif Parser::Rules.player_change?(line)
        process_player_change(line)
      elsif Parser::Rules.new_item?(line)
        process_new_item(line)
      elsif Parser::Rules.new_kill?(line)
        process_new_kill(line)
      end

      if @current_game
        current_time = Parser::Rules.current_time(line)
        @current_game.remove_expired_items(current_time)
      end
    end

    def process_new_game
      @current_game = Game.new
      @games << @current_game
    end

    def process_new_player(line)
      id = Parser::Rules.player_id(line)
      player = Player.new(id)
      @current_game.add_player(player)
    end

    def process_player_change(line)
      changes = Parser::Rules.player_change_info(line)
      player = @current_game.players[changes[:id]]
      player.name = changes[:name]
    end

    def process_new_item(line)
      info = Parser::Rules.new_item_info(line)
      item = Item.new(info[:name], info[:collected_at], info[:owner_id])
      @current_game.add_item(item)
    end

    def process_new_kill(line)
      kill_info = Parser::Rules.new_kill_info(line)
      killed_by_world = Parser::Rules.killed_by_world?(line)
      @current_game.change_items_ownership(kill_info[:killed_id], kill_info[:killer_id], killed_by_world)
    end
  end
end
