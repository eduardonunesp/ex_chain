defmodule ExChain.BlockchainTest do
  use ExUnit.Case

  alias ExChain.{
    Block,
    Blockchain
  }

  import ShorterMaps

  setup do
    blockchain = Blockchain.new()
      |> Blockchain.difficulty(1)
      |> Blockchain.create_genesis_block

    {:ok, blockchain: blockchain}
  end

  test "Test blockchain" do
    assert Blockchain.new() == %Blockchain{
      chain: [],
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
    blockchain = blockchain
    |> Blockchain.difficulty(4)
    |> Blockchain.add_block(Block.new("nops", "0"))
    |> Blockchain.add_block(Block.new("anops", "0"))

    assert length(blockchain.chain) == 3
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
