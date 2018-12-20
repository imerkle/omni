defmodule Omni.Neo.Crypto do
  #https://github.com/neo-project/neo/blob/master/neo/protocol.json  
  @address_version "17"

    def get_address(pubkey) do
      pubkey
      |> vscript_from_pubkey()
      |> Bip32.Utils.hash160()
      |> address_from_scripthash()
    end
    defp vscript_from_pubkey(pubkey) do
        "21" <> pubkey <> "ac"
    end    
    defp address_from_scripthash(script_hash) do
      <<checksum::binary-size(8), _rest::binary>> =  @address_version <> script_hash |> Bip32.Utils.sha256() |> Bip32.Utils.sha256()
      @address_version <> script_hash <> checksum
      |> Bip32.Utils.pack_h()
      |> Base58Check.encode58("123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz")
    end
end