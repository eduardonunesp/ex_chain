defmodule ExChain.TransactionTest do
  use ExUnit.Case

  alias ExChain.{
    Account,
    Transaction,
    Transaction.TxIn,
    Transaction.TxOut
  }

  test "Create a coinbase transaction" do
    address = Account.new |> Map.get(:address)

    transaction = Transaction.new
      |> Transaction.coinbase(true)
      |> Transaction.add_output(TxOut.new(1, address))

    assert length(transaction.inputs) == 0
    assert length(transaction.outputs) == 1
  end

  test "Create valid transactions between two addresses" do
    address_1 = Account.new |> Map.get(:address)
    address_2 = Account.new |> Map.get(:address)

    transaction = Transaction.new
      |> Transaction.coinbase(true)
      |> Transaction.add_output(TxOut.new(1, address_1))

    transaction = Transaction.new
      |> Transaction.add_input(TxIn.new(hd(transaction.outputs)))
      |> Transaction.add_output(TxOut.new(1, address_2))

    assert length(transaction.inputs) == 1
    assert length(transaction.outputs) == 1
  end
end
