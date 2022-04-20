# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/interface'

# rubocop: disable Metrics/BlockLength

describe Game do
  subject(:game) { described_class.new }

  describe '#initialize_players' do
    before do
      player_one = Player.new('Carlos', 'X')
      player_two = Player.new('Irina', 'O')

      allow(game).to receive(:create_player).and_return(player_one, player_two)
    end

    it 'initializes the players variable' do
      expect { game.initialize_players }.to change {
        game.instance_variable_get(:@players)
      }
        .from([]).to([Player, Player])
    end
  end

  describe '#create_player' do
    let(:number) { 0 }

    before do
      name = 'John'
      marker = 'X'
      allow(game).to receive(:get_name).with(number).and_return(name)
      allow(game).to receive(:select_marker).with(number).and_return(marker)
      allow(game).to receive(:set_marker_message).with(name, marker)
    end

    it 'returns a player' do
      expect(game.create_player(number)).to be_a Player
    end
  end

  describe '#get_name' do
    let(:number) { -1 }
    let(:name) { 'Susan' }

    before do
      allow(game).to receive(:get_name_message).with(number)
      allow(game).to receive(:gets).and_return(name)
    end

    it 'gets the player name' do
      expect(game.get_name(number)).to eq name
    end
  end

  describe '#select_marker' do
    it 'returns X when number is 0' do
      number = 0
      expect(game.select_marker(number)).to eq 'X'
    end

    it 'returns O when number is not 0' do
      number = 1
      expect(game.select_marker(number)).to eq 'O'
    end
  end

  describe '#game_loop' do
    let(:game_grid) { game.instance_variable_get(:@grid) }

    context 'when game have end condition' do
      before do
        allow(game_grid).to receive(:layout).once
        allow(game_grid).to receive(:end?).and_return(true)
      end

      it 'does not loop' do
        expect(game).to_not receive(:player_move)
        game.game_loop
      end
    end

    context 'when game have end condition after 1 move' do
      before do
        allow(game_grid).to receive(:layout).twice
        allow(game_grid).to receive(:end?).and_return(false, true)
      end

      it 'loops one time' do
        expect(game).to receive(:player_move).once
        game.game_loop
      end
    end

    context 'when game have end condition after 2 moves' do
      before do
        allow(game_grid).to receive(:layout).exactly(3).times
        allow(game_grid).to receive(:end?).and_return(false, false, true)
      end

      it 'loops two times' do
        expect(game).to receive(:player_move).twice
        game.game_loop
      end
    end
  end

  describe '#player_move' do
    let(:game_players) { game.instance_variable_get(:@players) }
    let(:slot) { [0, 0] }

    context 'when it is first player turn' do
      before do
        game.instance_variable_set(:@players, [Player.new('Ana', 'X'), Player.new('Julia', 'O')])
        allow(game).to receive(:get_input_message).with('Ana')
        allow(game).to receive(:player_input).and_return(slot)
      end

      it 'puts X on the chosen slot' do
        game_grid = game.instance_variable_get(:@grid)

        expect { game.player_move(0) }.to change { game_grid[slot.first][slot.last] }
          .from(' ').to('X')
      end
    end

    context 'when it is second player turn' do
      before do
        game.instance_variable_set(:@players, [Player.new('Ana', 'X'), Player.new('Julia', 'O')])
        allow(game).to receive(:get_input_message).with('Julia')
        allow(game).to receive(:player_input).and_return(slot)
      end

      it 'puts O on the chosen slot' do
        game_grid = game.instance_variable_get(:@grid)

        expect { game.player_move(1) }.to change { game_grid[slot.first][slot.last] }
          .from(' ').to('O')
      end
    end
  end

  describe '#player_input' do
    context 'when player inserts a valid slot' do
      let(:valid_slot) { '00' }
      let(:slot) { valid_slot.chars.map(&:to_i) }

      before do
        allow(game).to receive(:gets).and_return(valid_slot)
      end

      it 'returns slot' do
        expect(game.player_input).to eq(slot)
      end

      it 'does not show the error message' do
        expect(game).to_not receive(:error_message)
        game.player_input
      end
    end

    context 'when player inserts an invalid slot and a valid slot' do
      let(:invalid_slot) { '13' }
      let(:valid_slot) { '00' }
      let(:slot) { valid_slot.chars.map(&:to_i) }

      before do
        allow(game).to receive(:gets).and_return(invalid_slot, valid_slot)
      end

      it 'returns slot' do
        allow(game).to receive(:error_message).once
        expect(game.player_input).to eq(slot)
      end

      it 'shows the error message once' do
        expect(game).to receive(:error_message).once
        game.player_input
      end
    end
  end

  describe '#valid_slot?' do
    let(:possible_slot) { [1, 1] }
    let(:impossible_slot) { [-1, 0] }

    context 'when slot is possible and empty' do
      it 'returns true' do
        allow(game.instance_variable_get(:@grid)).to receive(:empty?).and_return(true)
        expect(game.valid_slot?(possible_slot)).to be true
      end
    end

    context 'when slot is possible and not empty' do
      it 'returns false' do
        allow(game.instance_variable_get(:@grid)).to receive(:empty?).and_return(false)
        expect(game.valid_slot?(possible_slot)).to be false
      end
    end

    context 'when slot is not possible and empty' do
      it 'returns false' do
        allow(game.instance_variable_get(:@grid)).to receive(:empty?).and_return(true)
        expect(game.valid_slot?(impossible_slot)).to be false
      end
    end

    context 'when slot is not possible and not empty' do
      it 'returns false' do
        allow(game.instance_variable_get(:@grid)).to receive(:empty?).and_return(false)
        expect(game.valid_slot?(impossible_slot)).to be false
      end
    end
  end

  describe '#game_end' do
    let(:player_one) { Player.new('Julius', 'X') }
    let(:player_two) { Player.new('Seth', 'O') }
    let(:game_players) { game.instance_variable_get(:@players) }

    context 'when it is a draw' do
      before do
        allow(game_players).to receive(:select).and_return([])
      end

      it 'shows draw message' do
        expect(game).to receive(:end_game_message).with(nil)
        game.game_end
      end
    end

    context 'when first player wins' do
      before do
        allow(game_players).to receive(:select).and_return([player_one])
      end

      it 'congratulates first player' do
        expect(game).to receive(:end_game_message).with(player_one.name)
        game.game_end
      end
    end

    context 'when second player wins' do
      before do
        allow(game_players).to receive(:select).and_return([player_two])
      end

      it 'congratulates second player' do
        expect(game).to receive(:end_game_message).with(player_two.name)
        game.game_end
      end
    end
  end
end

# rubocop: enable Metrics/BlockLength
