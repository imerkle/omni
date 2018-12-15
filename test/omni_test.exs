defmodule OmniTest do
  use ExUnit.Case
  #doctest Omni

  @mnemonic "connect ritual news sand rapid scale behind swamp damp brief explain ankle"
  @wallets [
    %{
      "address" => "1JN2GamM8pXmJvSRKxiRBppf9Zgur6Ze7L",
      "rel" => "BTC",
      "base" => "BTC",
    },
    %{
      "address" => "LfPqHoYgghwxjJt2BrjrqwPjhRwk69VFZx",
      "rel" => "LTC",
      "base" => "BTC",
    },
    %{
      "address" => "XyQ5Dc9abDeRpiihst9JY1M5fhTv4nKJL5",
      "rel" => "DASH",
      "base" => "BTC",
    }, 
    %{
      "address" => "0xb023b80afad0363ab966cf10b5f76E5f625Cf497",
      "rel" => "ETH",
      "base" => "ETH",
    }, 
  ]

  Enum.map(@wallets, fn x ->
    rel = x["rel"]
    base = x["base"]
    test "Generate Keys #{rel}" do
      { _wif, address, _public_key } = Omni.generate_seed(@mnemonic, "", %{rel: unquote(rel), base: unquote(base)})
      assert address |> String.upcase() == unquote(x["address"])  |> String.upcase()
    end
  end)

end
