defmodule ExChain.Blockchain do
  defstruct [:chain, :difficulty]

  alias ExChain.Block

  import ShorterMaps

  @initial_difficulty 3

  def new(difficulty \\ @initial_difficulty) do
    ~M{%__MODULE__
      chain: [],
      difficulty
    }
  end

  def create_genesis_block(blockchain) do
    block = Block.genesis(blockchain.difficulty)
      |> Block.mine(blockchain.difficulty)
    chain = [block]
    ~M{blockchain | chain}
  end

  def initial_difficulty, do: @initial_difficulty

  def difficulty(blockchain, difficulty) do
    ~M{blockchain | difficulty}
  end

  def last_block(blockchain) do
    with %{chain: [block|_]} = blockchain, do: block
  end

  def add_block(blockchain, new_block = %Block{}) do
    last_block = last_block(blockchain)
    new_block = new_block
      |> Block.prev_hash(last_block.hash)
      |> Block.mine(blockchain.difficulty)

    if !Block.valid?(new_block) do
      raise RuntimeError, message: "Invalid block"
    end

    chain = [new_block|blockchain.chain]
    ~M{blockchain | chain}
  end

  def valid? (blockchain) do
    Enum.all?(blockchain.chain, fn block ->
      Block.valid?(block)
    end)
  end
end
