defmodule ExChain.Transaction do
  defstruct [
    coinbase: false,
    inputs: [],
    outputs: []
  ]

  import ShorterMaps

  def new do
    %__MODULE__{}
  end

  def coinbase(transaction, coinbase) do
    ~M{transaction | coinbase}
  end

  def add_input(transaction, input) do
    ~M{inputs} = transaction
    inputs = [input|inputs]
    ~M{transaction | inputs}
  end

  def add_output(transaction, output) do
    ~M{outputs} = transaction
    outputs = [output|outputs]
    ~M{transaction | outputs}
  end
end
