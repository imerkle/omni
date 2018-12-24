defmodule Omni.Iota.Crypto do

    @radix 3
    @radix_bytes 256
    @max_trit_value 1
    @min_trit_value -1
    @byte_hash_length 48

    @trytes_alphabet "9ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    #map of all trits representations
    @trytes_trits [
        [ 0,  0,  0],
        [ 1,  0,  0],
        [-1,  1,  0],
        [ 0,  1,  0],
        [ 1,  1,  0],
        [-1, -1,  1],
        [ 0, -1,  1],
        [ 1, -1,  1],
        [-1,  0,  1],
        [ 0,  0,  1],
        [ 1,  0,  1],
        [-1,  1,  1],
        [ 0,  1,  1],
        [ 1,  1,  1],
        [-1, -1, -1],
        [ 0, -1, -1],
        [ 1, -1, -1],
        [-1,  0, -1],
        [ 0,  0, -1],
        [ 1,  0, -1],
        [-1,  1, -1],
        [ 0,  1, -1],
        [ 1,  1, -1],
        [-1, -1,  0],
        [ 0, -1,  0],
        [ 1, -1,  0],
        [-1,  0,  0],
    ]

    @doc """
    *   Converts trytes into trits
    *
    *   @method trits
    *   @param {String|Int} input Tryte value to be converted. Can either be string or int
    *   @param {Array} state (optional) state to be modified
    *   @returns {Array} trits
    """
    defp set_trits(trits, absolute_value) do
        remainder = rem(absolute_value, 3)
        absolute_value = Integer.floor_div(absolute_value, 3)
        {remainder, absolute_value} = if remainder > 1 do {-1, absolute_value+1} else {remainder, absolute_value} end
        trits = if absolute_value > 0 do
            l = trits |> length()
            trits 
                |> List.insert_at(l, remainder) 
                |> List.delete_at(l+1)
                |> set_trits(absolute_value)
        end || trits
    end
    def trits(input, state \\ []) when is_integer(input) do
        absolute_value = if input < 0 do -input else input end
        trits = set_trits(state, absolute_value)
        trits = if input < 0 do Enum.map(trits, fn x -> -x end) end || trits
    end
    def trits(input, state) do
        put_trytes(state, input, 0)
    end    
    defp put_trytes(trits, input, i) do
        {index, _l} = :binary.match(@trytes_alphabet, String.at(input, i))
        t = @trytes_trits |> Enum.at(index)
        trits = trits|> List.insert_at(i*3 + 0, t |> Enum.at(0) ) |> List.delete_at(i*3 + 1)
        trits = trits |> List.insert_at(i*3 + 1, t |> Enum.at(1) )  |> List.delete_at(i*3 + 2)
        trits = trits |> List.insert_at(i*3 + 2, t |> Enum.at(2) ) |> List.delete_at(i*3 + 3)
        trits = if i < String.length(input) do
            put_trytes(trits, input, i+1)
        end || trits
    end

    @doc """
    *   Converts trits into trytes
    *
    *   @method trytes
    *   @param {Array} trits
    *   @returns {String} trytes 

    2076781702711090825446814413200646823316344226182437528247761865016157475258495735463461605228517154935066745100925414320245433705442593647465697148919201 |> Omni.Iota.Crypto.from_value() |> Omni.Iota.Crypto.trytes()

    """
    defp trytes_j(trits, i, trytes, j) do
        {trytes, has_broken} = if @trytes_trits |> Enum.at(j) |> Enum.at(0) === trits |> Enum.at(i) and
        @trytes_trits |> Enum.at(j) |> Enum.at(1) === trits |> Enum.at(i+1) and
        @trytes_trits |> Enum.at(j) |> Enum.at(2) === trits |> Enum.at(i+2) do
                alpha = @trytes_alphabet |> String.at(j)
                {trytes <> alpha, true}
            end || {trytes, false}
        trytes = if !has_broken and j < String.length(@trytes_alphabet)-1 do trytes_j(trits, i, trytes, j+1) end || trytes
    end
    defp trytes_i(trits, i, trytes) do
        trytes = trytes_j(trits, i, trytes, 0)
        trytes = if i < length(trits)-1 do trytes_i(trits, i+3, trytes) end || trytes
    end
    def trytes(trits) do
        trytes = trytes_i(trits, 0, "")
    end 
    @doc """
    /**
    *   Converts trits into an integer value
    *
    *   @method value
    *   @param {Array} trits
    *   @returns {int} value
    **/
    """
    def value(return_value, _trits, _i), do: return_value
    def value(return_value, trits, i) when i > 0 do
        return_value = return_value * 3 + Enum.at(trits, i)
                        |> value(trits, i-1)
    end

    @doc """
    *   Converts an integer value to trits
    *
    *   @method value
    *   @param {Int} value
    *   @returns {Array} trits
500000000000000000000000000000 |> Omni.Iota.Crypto.from_value()    
    """
    def  pow(n, k), do: pow(n, k, 1)        
    defp pow(_, 0, acc), do: acc
    defp pow(n, k, acc), do: pow(n, k - 1, n * acc)

    defp put_destination(destination, absolute_value, i) when absolute_value > 0 do
        l = absolute_value |> Integer.digits() |> length()
        abs = if l > 17 do
             p = pow(10, l-16)
             Integer.floor_div(absolute_value, p) * p
        end || absolute_value
        remainder = rem(abs, @radix)
        absolute_value = Integer.floor_div(absolute_value, @radix)
        {remainder, absolute_value}  = if remainder > @max_trit_value do
            {@min_trit_value, absolute_value + 1}
        end || {remainder, absolute_value}
        IO.inspect abs
        IO.inspect remainder
        destination = destination |> List.insert_at(i, remainder) |> List.delete_at(i+1)
                        |> put_destination(absolute_value, i+1)
    end
    defp put_destination(destination, _absolute_value, _i), do: destination
    defp put_destination2(destination, j) do
        input = if Enum.at(destination, j) === 0 do  0 else -Enum.at(destination, j) end
        destination = destination |> List.insert_at(j, input) |> List.delete_at(j+1)
        destination = if j < length(destination) do put_destination2(destination, j+1) end || destination
    end
    def from_value(value) do 
        absolute_value = if value < 0 do -value end || value
        destination = put_destination([], absolute_value, 0)
        destination = if value < 0 do
            put_destination2(destination, 0)
        end || destination
    end
end