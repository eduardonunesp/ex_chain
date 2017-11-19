defmodule ExChain.BlockTest do
  use ExUnit.Case

  alias ExChain.Block

  test "Mine block difficult 1" do
    block = Block.genesis(1)
    assert block = Block.mine(block, 1)
    assert Block.valid?(block)
  end

  test "Mine block difficult 2" do
    block = Block.genesis(2)
    assert block = Block.mine(block, 2)
    assert Block.valid?(block)
  end

  test "Mine block difficult 3" do
    block = Block.genesis(3)
    assert block = Block.mine(block, 3)
    assert Block.valid?(block)
  end

  test "Mine block difficult 4" do
    block = Block.genesis(4)
    assert block = Block.mine(block, 4)
    assert Block.valid?(block)
  end

  test "Is block valid" do
    block = Block.genesis(3)
      |> Block.mine(3)

    assert Block.valid?(block)
  end
end
