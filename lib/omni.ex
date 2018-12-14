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
  def generate_seed(mnemonic \\ "", passphrase \\ "", options) do
    mnemonic = if (mnemonic != ""), do: mnemonic, else: Mnemonic.generate(256)
    seed = Mnemonic.mnemonic_to_seed(mnemonic, passphrase)
    generate_pkey(options.rel, options.base, seed)
  end
  defp generate_pkey(rel, base, seed, account \\ 0, change \\ 0, index \\ 0) do
    #root node is master derived from mnemonic -> seed -> root node
    root_node = get_root_node(seed, rel, base)
    child_node = get_child_node(root_node, account, change, index, rel)

    get_wallet(child_node, rel, base)
  end
  
  defp get_root_node(seed, rel, base) do
    root_node = case base do
      "BTC" -> Bip32.Node.generate_master_node(seed)
    end
  end
  defp get_child_node(root_node, account, change, index, rel) do
    network_code = @coins[rel]["code"]
    bip44path = "m/44'/#{network_code}'/#{account}'/#{change}/#{index}"
    Bip32.Node.derive_descendant_by_path(root_node, bip44path)
  end
  defp get_wallet(child_node, rel, base) do
    address = case base do
      "BTC" -> child_node.public_key
                |> Bip32.Utils.hash160()
                |> Base58Check.encode58check(@coins[rel]["network"]["versions"]["public"])
    end

    wif = child_node.private_key
          |> Base58Check.encode58check(@coins[rel]["network"]["versions"]["private"], true)
    public_key = child_node.public_key
    {wif, address, public_key }
  end


end
