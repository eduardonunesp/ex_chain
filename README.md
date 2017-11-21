# ExChain [![Build Status](https://semaphoreci.com/api/v1/eduardonunesp/ex_chain/branches/master/badge.svg)](https://semaphoreci.com/eduardonunesp/ex_chain)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_chain` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_chain, "~> 0.1.0"}
  ]
end
```

## About

ExChain is a initial implementation of a distributed ledger and is based on the bitcoin ledger. The current state is ultra simple, but is open for improvenment. The current consensus algorithm is the proof of work.

### Components 
- Chain (List)
- Account
- Block
- Transaction
  - TxIn / TxOut
