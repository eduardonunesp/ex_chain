defmodule ExChain.BlockchainTest do
  use ExUnit.Case

  alias ExChain.{
    Account,
    Block,
    Blockchain,
    Transaction,
    Transaction.TxOut
  }

  import ShorterMaps

  setup do
    account = Account.new
    blockchain = Blockchain.new()
      |> Blockchain.coinbase(account)
      |> Blockchain.difficulty(1)
      |> Blockchain.create_genesis_block

    {:ok, blockchain: blockchain}
  end

  test "Test blockchain" do
    assert Blockchain.new() == %Blockchain{
      chain: [],
      accounts: [],
      difficulty: Blockchain.initial_difficulty
    }
  end

  test "Create genesis block", ~M{blockchain} do
    %{chain: chain} = blockchain
    assert [block] = chain
    assert block.data == "Genesis"
    assert block.prev_hash == "0"
    assert is_number(block.timestamp)
  end

  test "Get first block", ~M{blockchain} do
    block = Blockchain.last_block(blockchain)
    assert block
  end

  test "Add new block", ~M{blockchain} do
    account_1 = Account.new
    account_2 = Account.new

    blockchain = blockchain
    |> Blockchain.add_account(account_1)
    |> Blockchain.add_account(account_2)
    |> Blockchain.difficulty(3)
    |> Blockchain.add_block(Block.new)

    assert length(blockchain.chain) == 2
  end

  test "Check blockchain integrity", ~M{blockchain} do
    blockchain = blockchain
    |> Blockchain.difficulty(2)
    |> Blockchain.add_block(Block.new("good"))
    |> Blockchain.add_block(Block.new("super good"))
    |> Blockchain.add_block(Block.new("super goods"))

    assert Blockchain.valid?(blockchain)
  end
end
