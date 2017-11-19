defmodule ExChain.Block do
  defstruct [:timestamp, :data, :hash, :calculated_hash, :prev_hash, :difficulty, :nonce]

  import ShorterMaps

  def new(data \\ "", prev_hash \\ "0") do
    hash = calc_hash(timestamp(), data, prev_hash, 0)

    ~M{%__MODULE__
      timestamp(),
      data,
      prev_hash,
      hash,
      calculated_hash: "0",
      nonce: 0
    }
  end

  def genesis(difficulty \\ 1) do
    new("Genesis", "0")
    |> set_difficulty(difficulty)
  end

  def mine(block, difficulty) do
    block = block
      |> set_difficulty(difficulty)
      |> calculated_hash(calc_hash(block))

    cond do
      slice_hash(block.calculated_hash, difficulty) == left_zeros(difficulty) -> block
      :else ->
        block
        |> incr_nonce
        |> mine(difficulty)
    end
  end

  def valid?(block) do
    calc_hash(block) == block.calculated_hash
  end

  def calc_hash(block) do
    calc_hash(block.timestamp, block.data, block.prev_hash, block.nonce)
  end

  def calc_hash(timestamp, data, prev_hash, nonce) do
    block_combo = "#{prev_hash}#{timestamp}#{data}#{nonce}"
    :crypto.hash(:sha256, block_combo) |> Base.encode16 |> String.downcase
  end

  def set_difficulty(block, difficulty) do
    ~M{block | difficulty}
  end

  def slice_hash(hash, difficulty) do
    String.slice(hash, 0..difficulty-1)
  end

  def left_zeros(n) do
    zeros = for _ <- 1..n, do: "0"
    zeros |> Enum.join("")
  end

  def timestamp do
    DateTime.utc_now |> DateTime.to_unix
  end

  def hash(block, hash) do
    ~M{block | hash}
  end

  def prev_hash(block, prev_hash) do
    ~M{block | prev_hash}
  end

  def calculated_hash(block, calculated_hash) do
    ~M{block | calculated_hash}
  end

  def incr_nonce(block) do
    ~M{block | nonce: block.nonce + 1}
  end
end
