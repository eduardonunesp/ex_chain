defmodule ExChain.Blockchain do
  defstruct [
    :chain,
    :difficulty,
    :accounts,
    :coinbase
  ]

  alias ExChain.{
    Block,
    Transaction
  }

  require Logger

  import ShorterMaps

  @initial_difficulty 3

  def new(difficulty \\ @initial_difficulty) do
    ~M{%__MODULE__
      chain: [],
      difficulty,
      accounts: [],
      coinbase: nil
    }
  end

  def create_genesis_block(blockchain) do
    block = Block.genesis(blockchain.difficulty)
      |> Block.mine(blockchain.difficulty)
    chain = [block]

    Logger.debug("Genesis block created #{block.hash}")
    ~M{blockchain | chain}
  end

  def initial_difficulty, do: @initial_difficulty

  def difficulty(blockchain, difficulty) do
    ~M{blockchain | difficulty}
  end

  def add_account(blockchain, account) do
    Logger.debug("Creating account #{account.address}")
    if blockchain.coinbase == nil do
      coinbase(blockchain, account)
    else
      ~M{accounts} = blockchain
      accounts = [account|accounts]
      ~M{blockchain | accounts}
    end
  end

  def coinbase(blockchain, coinbase) do
    Logger.debug("Creating coinbase account #{coinbase.address}")
    blockchain = if !Enum.any?(blockchain.accounts, &(&1.address == coinbase.address)) do
      accounts = [coinbase]
      ~M{blockchain | accounts}
    else
      blockchain
    end
    ~M{blockchain | coinbase}
  end

  def last_block(blockchain) do
    with %{chain: [block|_]} = blockchain, do: block
  end

  def add_block(blockchain, new_block = %Block{}) do
    last_block = last_block(blockchain)
    new_block = new_block
      |> Block.prev_hash(last_block.hash)
      |> Block.mine(blockchain.difficulty)

    Logger.debug("New block hash #{new_block.hash}")

    if !Block.valid?(new_block) do
      raise RuntimeError, message: "Invalid block"
    end

    new_block = add_block_reward(blockchain, new_block)

    chain = [new_block|blockchain.chain]
    ~M{blockchain | chain}
  end

  def valid? (blockchain) do
    Enum.all?(blockchain.chain, fn block ->
      Block.valid?(block)
    end)
  end

  defp add_block_reward(blockchain, block) do
    transaction = Transaction.new
      |> Transaction.coinbase(true)
      |> Transaction.add_output(Transaction.TxOut.new(10, blockchain.coinbase.address))

    Logger.debug("Mined #{block.hash} mint address #{blockchain.coinbase.address}")
    Block.add_transaction(block, transaction)
  end
end
