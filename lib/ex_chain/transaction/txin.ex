defmodule ExChain.Transaction.TxIn do
  defstruct [
    :prev_out
  ]

  import ShorterMaps

  def new(prev_out) do
    ~M{%__MODULE__
      prev_out
    }
  end
end
