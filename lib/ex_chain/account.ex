defmodule ExChain.Account do
  defstruct [
    :address
  ]

  def new do
    %__MODULE__{
      address: UUID.uuid4()
    }
  end
end
