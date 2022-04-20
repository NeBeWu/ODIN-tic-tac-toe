# frozen_string_literal: true

require_relative '../lib/grid'

# rubocop: disable Metrics/BlockLength

describe Grid do
  subject(:grid) { described_class.new }

  describe '#[]' do
    context 'when no move was made' do
      it 'shows an empty first row' do
        string_array = [' ', ' ', ' ']
        expect(grid[0]).to eq(string_array)
      end

      it 'shows an empty second row' do
        string_array = [' ', ' ', ' ']
        expect(grid[1]).to eq(string_array)
      end

      it 'shows an empty third row' do
        string_array = [' ', ' ', ' ']
        expect(grid[2]).to eq(string_array)
      end
    end

    context 'when some moves were made' do
      before do
        grid.instance_variable_set(:@rows, [
                                     ['X', 'O', ' '],
                                     [' ', 'X', ' '],
                                     [' ', ' ', 'O']
                                   ])
      end

      it 'shows all moves on first row' do
        string_array = ['X', 'O', ' ']
        expect(grid[0]).to eq(string_array)
      end

      it 'shows all moves on second row' do
        string_array = [' ', 'X', ' ']
        expect(grid[1]).to eq(string_array)
      end

      it 'shows all moves on third row' do
        string_array = [' ', ' ', 'O']
        expect(grid[2]).to eq(string_array)
      end
    end
  end

  describe '#[]=' do
    context 'when no move was made' do
      it 'assigns values to first row' do
        start_array = [' ', ' ', ' ']
        assign_array = ['X', 'O', ' ']
        expect { grid[0] = assign_array }.to change { grid[0] }
          .from(start_array).to(assign_array)
      end

      it 'assigns values to second row' do
        start_array = [' ', ' ', ' ']
        assign_array = ['O', ' ', 'X']
        expect { grid[1] = assign_array }.to change { grid[1] }
          .from(start_array).to(assign_array)
      end

      it 'assigns values to third row' do
        start_array = [' ', ' ', ' ']
        assign_array = [' ', 'X', ' ']
        expect { grid[2] = assign_array }.to change { grid[2] }
          .from(start_array).to(assign_array)
      end
    end
  end

  describe '#empty?' do
    context 'when slot is empty' do
      it 'returns true' do
        empty_slot = grid.empty?(0, 0)
        expect(empty_slot).to be true
      end
    end

    context 'when slot is not empty' do
      before do
        grid.instance_variable_set(:@rows, [
                                     ['X', 'O', ' '],
                                     [' ', 'X', ' '],
                                     [' ', ' ', 'O']
                                   ])
      end

      it 'returns false' do
        empty_slot = grid.empty?(1, 1)
        expect(empty_slot).to be false
      end
    end
  end

  describe '#full?' do
    context 'when board is empty' do
      it 'returns false' do
        expect(grid).to_not be_full
      end
    end

    context 'when board is partially full' do
      before do
        grid.instance_variable_set(:@rows, [
                                     [' ', ' ', 'O'],
                                     [' ', 'X', ' '],
                                     ['X', ' ', 'O']
                                   ])
      end

      it 'returns false' do
        expect(grid).to_not be_full
      end
    end

    context 'when board is full' do
      before do
        grid.instance_variable_set(:@rows, [
                                     %w[X X O],
                                     %w[O X X],
                                     %w[X O O]
                                   ])
      end

      it 'returns true' do
        expect(grid).to be_full
      end
    end
  end

  describe '#check_rows' do
    context 'when no matching row' do
      before do
        grid.instance_variable_set(:@rows, [
                                     ['O', 'X', ' '],
                                     [' ', 'X', ' '],
                                     [' ', 'O', ' ']
                                   ])
      end

      it 'returns nil' do
        expect(grid.check_rows).to be_nil
      end

      context 'when X has a matching row' do
        before do
          grid.instance_variable_set(:@rows, [
                                       %w[X X X],
                                       %w[O X O],
                                       %w[O X O]
                                     ])
        end

        it 'returns X' do
          expect(grid.check_rows).to be('X')
        end
      end

      context 'when O has a matching row' do
        before do
          grid.instance_variable_set(:@rows, [
                                       [' ', 'X', ' '],
                                       ['X', 'X', ' '],
                                       %w[O O O]
                                     ])
        end

        it 'returns O' do
          expect(grid.check_rows).to be('O')
        end
      end
    end
  end

  describe '#check_columns' do
    context 'when no matching row' do
      before do
        grid.instance_variable_set(:@rows, [
                                     ['O', 'O', ' '],
                                     %w[O X X],
                                     %w[X O X]
                                   ])
      end

      it 'returns nil' do
        expect(grid.check_columns).to be_nil
      end

      context 'when X has a matching row' do
        before do
          grid.instance_variable_set(:@rows, [
                                       %w[X O X],
                                       %w[X X O],
                                       %w[X O O]
                                     ])
        end

        it 'returns X' do
          expect(grid.check_columns).to be('X')
        end
      end

      context 'when O has a matching row' do
        before do
          grid.instance_variable_set(:@rows, [
                                       ['O', ' ', ' '],
                                       ['O', 'X', ' '],
                                       %w[O X X]
                                     ])
        end

        it 'returns O' do
          expect(grid.check_columns).to be('O')
        end
      end
    end
  end

  describe '#check_diagonals' do
    context 'when no matching row' do
      before do
        grid.instance_variable_set(:@rows, [
                                     ['O', 'O', ' '],
                                     %w[O X X],
                                     %w[X O X]
                                   ])
      end

      it 'returns nil' do
        expect(grid.check_diagonals).to be_nil
      end
    end

    context 'when X has a matching row' do
      before do
        grid.instance_variable_set(:@rows, [
                                     %w[X O X],
                                     %w[O X O],
                                     %w[X X O]
                                   ])
      end

      it 'returns X' do
        expect(grid.check_diagonals).to be('X')
      end
    end

    context 'when O has a matching row' do
      before do
        grid.instance_variable_set(:@rows, [
                                     ['O', ' ', ' '],
                                     ['X', 'O', ' '],
                                     %w[X X O]
                                   ])
      end

      it 'returns O' do
        expect(grid.check_diagonals).to be('O')
      end
    end
  end

  describe '#winner?' do
    context 'when all checks are false' do
      before do
        allow(grid).to receive(:check_rows).and_return(false)
        allow(grid).to receive(:check_columns).and_return(false)
        allow(grid).to receive(:check_diagonals).and_return(false)
      end

      it 'returns false' do
        expect(grid).to_not be_winner
      end
    end

    context 'when check_rows is true' do
      before do
        allow(grid).to receive(:check_rows).and_return(true)
        allow(grid).to receive(:check_columns).and_return(false)
        allow(grid).to receive(:check_diagonals).and_return(false)
      end

      it 'returns true' do
        expect(grid).to be_winner
      end
    end

    context 'when check_columns is true' do
      before do
        allow(grid).to receive(:check_rows).and_return(false)
        allow(grid).to receive(:check_columns).and_return(true)
        allow(grid).to receive(:check_diagonals).and_return(false)
      end

      it 'returns true' do
        expect(grid).to be_winner
      end
    end

    context 'when check_diagonals is true' do
      before do
        allow(grid).to receive(:check_rows).and_return(false)
        allow(grid).to receive(:check_columns).and_return(false)
        allow(grid).to receive(:check_diagonals).and_return(true)
      end

      it 'returns true' do
        expect(grid).to be_winner
      end
    end
  end

  describe '#end?' do
    context 'when no winner and not full' do
      before do
        allow(grid).to receive(:winner?).and_return(false)
        allow(grid).to receive(:full?).and_return(false)
      end

      it 'returns false' do
        expect(grid).to_not be_end
      end
    end

    context 'when there is a winner' do
      before do
        allow(grid).to receive(:winner?).and_return(true)
        allow(grid).to receive(:full?).and_return(false)
      end

      it 'returns true' do
        expect(grid).to be_end
      end
    end

    context 'when grid is full' do
      before do
        allow(grid).to receive(:winner?).and_return(false)
        allow(grid).to receive(:full?).and_return(true)
      end

      it 'returns true' do
        expect(grid).to be_end
      end
    end
  end
end

# rubocop: enable Metrics/BlockLength
