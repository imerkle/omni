defmodule OmniTest do
  use ExUnit.Case
  #doctest Omni

  @mnemonic "connect ritual news sand rapid scale behind swamp damp brief explain ankle"
  @wallets [
    %{
      "address" => "1JN2GamM8pXmJvSRKxiRBppf9Zgur6Ze7L",
      "rel" => "BTC",
      "base" => "BTC",
    }
  ]

  Enum.map(@wallets, fn x ->
    rel = x["rel"]
    base = x["base"]
    test "Generate Keys #{rel}" do
      { _wif, address, _public_key } = Omni.generate_seed(@mnemonic, "", %{rel: unquote(rel), base: unquote(base)})
      assert address == unquote(x["address"])
    end
  end)

end
