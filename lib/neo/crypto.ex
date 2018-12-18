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
      checksum = @address_version <> script_hash
                  |> Bip32.Utils.sha256()
                  |> String.slice(0..8)
      @address_version <> script_hash <> checksum
      |> Base58Check.encode58()
    end
end
"""
function getAddressFromScriptHash(scriptHash) {
    if (scriptHash.length !== 20) throw new Error('Invalid ScriptHash length')

    const ADDRESS_VERSION = 23 // addressVersion https://github.com/neo-project/neo/blob/master/neo/protocol.json

    let inputData = new Buffer(scriptHash.length + 1)
    inputData.writeInt8(ADDRESS_VERSION, 0)
    inputData.fill(scriptHash, 1)

    let scriptHashHex = CryptoJS.enc.Hex.parse(inputData.toString('hex'))
    let scriptHashSha256 = CryptoJS.SHA256(scriptHashHex)
    let scriptHashSha256_2 = CryptoJS.SHA256(scriptHashSha256)
    let scriptHashShaBuffer = new Buffer(scriptHashSha256_2.toString(), 'hex')

    const checksum = scriptHashShaBuffer.slice(0, 4)
    let outputData = new Buffer(1 + scriptHash.length + checksum.length)
    outputData.fill(inputData, 0)
    outputData.fill(checksum, inputData.length)

    return bs58.encode(outputData)
}
"""