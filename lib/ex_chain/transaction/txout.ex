defmodule ExChain.Transaction.TxOut do
  defstruct [
    :amount,
    :address,
    :hash
  ]

  alias ExChain.{
    Account
  }

  import ShorterMaps

  def new(amount, %Account{} = account) do
    new(amount, account.address)
  end

  def new(amount, address) do
    hash = calc_hash(timestamp(), amount, address)

    ~M{%__MODULE__
      amount,
      address,
      hash
    }
  end

  def calc_hash(timestamp, amount, address) do
    block_combo = "#{timestamp}#{amount}#{address}"
    :crypto.hash(:sha256, block_combo) |> Base.encode16 |> String.downcase
  end

  def timestamp do
    DateTime.utc_now |> DateTime.to_unix
  end
end
