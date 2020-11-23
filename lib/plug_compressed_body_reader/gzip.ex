defmodule PlugCompressedBodyReader.Gzip do
  @moduledoc """
  Safe gzip decompression.

  Options:
    - `:max_chunks`(pos_integer()) - The max number of decompressed chunks you would like to allow.
    The size of a chunk could potentially change in different versions of Erlang, but
    [at the time of writing it is](https://github.com/erlang/otp/blob/809367fcf38f3290409c80b05cf434096aea401c/erts/preloaded/src/zlib.erl#L91) 
    `16_384` bytes. Defaults to `4`.
  """
  @behaviour PlugCompressedBodyReader.Decompressor
  @default_max_chunks 4

  @impl true
  def decompress(data, opts \\ []) do
    max_chunks = Keyword.get(opts, :max_chunks, @default_max_chunks)
    z = :zlib.open()

    try do
      :zlib.inflateInit(z, 31, :reset)
      bytes = safeInflate(z, data, max_chunks, opts)
      :zlib.inflateEnd(z)
      {:ok, IO.iodata_to_binary(bytes)}
    rescue
      e ->
        {:error, Exception.message(e)}
    after
      :zlib.close(z)
    end
  end

  defp safeInflate(z, data, max_chunks, opts) do
    z
    |> :zlib.safeInflate(data)
    |> safeInflate(z, 0, max_chunks, opts, [])
  end

  defp safeInflate(_, _, max_chunks, max_chunks, _, _) do
    raise RuntimeError, "max chunks reached"
  end

  defp safeInflate({:continue, output}, z, current_chunk, max, opts, acc) do
    z
    |> :zlib.safeInflate([])
    |> safeInflate(z, current_chunk + 1, max, opts, [output | acc])
  end

  defp safeInflate({:finished, output}, _, _, _, _, acc) do
    Enum.reverse([output | acc])
  end
end
