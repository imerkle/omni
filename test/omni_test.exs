defmodule OmniTest do
  use ExUnit.Case
  #doctest Omni

  @mnemonic "connect ritual news sand rapid scale behind swamp damp brief explain ankle"
  @seed_hex "27a718f64d256afa9d95a1d561f059f8a2488c87b2ff56eaeee1ff8dac465804a54400f70205ee698c1b3e2cad4c5b8117f892878dea6d585c6db7e42ab3dda1"
  #CXMZDVGCVALGB9AZIQMKFAJY9YZ9PGMEVKVAXOSXRLV9HKJTMRSQDZZNECQCCYKAAJXJJZUMNPXTECKEK iota
  #2076781702711090825446814413200646823316344226182437528247761865016157475258495735463461605228517154935066745100925414320245433705442593647465697148919201 iota
  @wallets [
    %{
      "address" => "1JN2GamM8pXmJvSRKxiRBppf9Zgur6Ze7L",
      "wif" => "KwxFiVzM64x3SEgyYnzCDf8xh3s3Ber66GeD23HkdGrsdKvhGAnf",
      "public_key" => "03bc140f5f9970ea9b2888f808b117e25949fcf4825ca14929ba12b7a310c6b351",
      "rel" => "BTC",
      "base" => "BTC",
    },
    %{
      "address" => "LfPqHoYgghwxjJt2BrjrqwPjhRwk69VFZx",
      "wif" => "T9ZxCWN8guvnX2UYkGLx3nWGC4xym1fH6cRMWDXY9mVETyoFx6xP",
      "public_key" => "030b64436288da08229024009879b5085b1b26a69543a416bde661e329fec73158",
      "rel" => "LTC",
      "base" => "BTC",
    },
    %{
      "address" => "XyQ5Dc9abDeRpiihst9JY1M5fhTv4nKJL5",
      "wif" => "XJh35xpP39mjGjN6UBpx58MhWWA8KVZktBzbtrrcjKVzxxYMKUie",
      "public_key" => "03a6a92e3cf75be1f5409977acc8ff537d1cdead3e22dcf234e858dc9346c7ba1c",
      "rel" => "DASH",
      "base" => "BTC",
    }, 
    %{
      "address" => "0xb023b80afad0363ab966cf10b5f76E5f625Cf497",
      "wif" => "0x68d473d56faa29c81138d2830aa6cfe8323feb35da3e311929fb29eea25fb8dc",
      "public_key" => "0x03979f591ae21a27a518479b3a58afbf99b8807a77e4e7b1233d95300a1c19b3f2",
      "rel" => "ETH",
      "base" => "ETH",
    }, 
    %{
      "address" => "0x684e90C1e5aB7449988D3180C34A99f92A54b705",
      "wif" => "0x39188da8d0f5e30082d295abc589b5c7c31ddb65781b317947f15dfae53bbb9e",
      "public_key" => "0x029f3e29b4fb71f2e732dfdac1d17cf75893136164973bf5edee6753f4065bf284",      
      "rel" => "VET",
      "base" => "VET",
    },
    %{
      "address" => "EOS5ZXHpkLdY9qqYLEL5D5VPwZop9BrF6pCMT4QauJJzkrA7xitfA",
      "wif" => "5K7V5He9abzwEavLTEVeWj4U9xEtVdnrGD4jc5piNvmbAz45mcS",
      "public_key" => "EOS5ZXHpkLdY9qqYLEL5D5VPwZop9BrF6pCMT4QauJJzkrA7xitfA",      
      "rel" => "EOS",
      "base" => "EOS",
    },
    %{
      "address" => "AShDKgLSuCjGZr8Fs5SRLSYvmcSV7S4zwX",
      "wif" => "KwmYnVNazav2fWiFjTaU4SdK9bVsg1J1FQcaAkqYVa196XifCrp2",
      "public_key" => "03f7f87c8988579de62bd416958e8c27da8e7948a2639c1027eb37e386f10badcf",      
      "rel" => "NEO",
      "base" => "NEO",
    },
    %{
      "address" => "rPphbLGemSQv4De1LUHYq6tupBkrrZUxNe",
      "wif" => "f8b9412446e9328262cc158f03472b6450c3cf19b9db5c3975c15a84f3189123",
      "public_key" => "031f5b18658ba210dca0fe2669b2dd51b9ad12964efbcfa4a56774e4375e968263",      
      "rel" => "XRP",
      "base" => "XRP",
    },
  ]

  Enum.map(@wallets, fn x ->
    rel = x["rel"]
    base = x["base"]
    test "Generate Keys #{rel}" do
      seed = Omni.generate_seed(@mnemonic, "")
      assert seed == @seed_hex
      { wif, private_key, public_key, address } = Omni.generate_keys(unquote(rel), unquote(base), seed)
      assert wif |> String.upcase() == unquote(x["wif"])  |> String.upcase()
      assert public_key |> String.upcase() == unquote(x["public_key"])  |> String.upcase()
      assert address |> String.upcase() == unquote(x["address"])  |> String.upcase()
    end
  end)

end
 