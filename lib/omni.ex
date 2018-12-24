defmodule Omni do
  @moduledoc """
  Documentation for Omni.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Omni.hello()
      :world

  """
  @coins Application.get_env(:omni, :coins)
  def generate_seed(mnemonic \\ "", passphrase \\ "") do
    mnemonic = if (mnemonic != ""), do: mnemonic, else: Mnemonic.generate(256)
    seed = Mnemonic.mnemonic_to_seed(mnemonic, passphrase)
  end
  def generate_keys(rel, base, seed, account \\ 0, change \\ 0, index \\ 0) do
    #root node is master derived from mnemonic -> seed -> root node
    root_node = get_root_node(seed, rel, base)
    child_node = get_child_node(root_node, account, change, index, rel)

    get_wallet(child_node, rel, base)
  end
  
  defp get_root_node(seed, rel, base) do
    root_node = case base do
      "NEO" -> Bip32.Node.generate_master_node(seed, :secp256r1, "Nist256p1 seed")
      _ -> Bip32.Node.generate_master_node(seed)
    end
  end
  defp get_child_node(root_node, account, change, index, rel) do
    network_code = @coins[rel]["code"]
    bip44path = "m/44'/#{network_code}'/#{account}'/#{change}/#{index}"
    Bip32.Node.derive_descendant_by_path(root_node, bip44path)
  end
  defp get_wallet(child_node, rel, base) do
    address = case base do
      n when n in ["BTC"] -> child_node.public_key
                |> Bip32.Utils.hash160()
                |> Base58Check.encode58check(@coins[rel]["network"]["versions"]["public"])
      n when n in ["ETH", "VET"] -> <<4::size(8), key::binary-size(64)>> = child_node.public_key_uncompressed |> Bip32.Utils.pack_h()
               <<_::binary-size(12), eth_address::binary-size(20)>> = key |> keccak256()
                
               e_a = eth_address |> Base.encode16()
               "0x" <> e_a
      "EOS" -> p = child_node.public_key
                |> Base58Check.encode58check("", false, "ripemd160")
                "EOS" <> p
      "NEO" ->  child_node.public_key 
                  |> Omni.Neo.Crypto.get_address()
      "XRP" ->  child_node.public_key 
                  |> Bip32.Utils.hash160()
                  |> Base58Check.encode58check(0, false, "256x2", "rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdeCg65jkm8oFqi1tuvAxyz")
      _-> child_node.public_key
    end

    wif = case base do
      n when n in ["BTC", "NEO"] -> child_node.private_key
                |> Base58Check.encode58check(@coins[rel]["network"]["versions"]["private"], true)
      n when n in ["ETH", "VET"] -> "0x" <> child_node.private_key
      "EOS" -> child_node.private_key
                |> Base58Check.encode58check(@coins[rel]["network"]["versions"]["private"], false)
      _-> child_node.private_key
    end
    public_key = case base do
      n when n in ["ETH", "VET"] -> "0x" <> child_node.public_key
      "EOS" -> address
      _-> child_node.public_key
    end

    private_key = case base do
      n when n in ["ETH", "VET"] -> "0x" <> child_node.private_key
      _-> child_node.private_key
    end

    {wif, private_key, public_key, address}
  end
  defp keccak256(data), do: :keccakf1600.hash(:sha3_256, data)
end
