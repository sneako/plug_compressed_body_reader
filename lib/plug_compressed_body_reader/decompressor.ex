defmodule PlugCompressedBodyReader.Decompressor do
  @moduledoc false

  @type opts :: Keyword.t()
  @type compressed :: binary()
  @type decompressed :: binary()

  @callback decompress(compressed(), opts()) ::
              {:ok, decompressed()} | {:error, reason :: binary()}
end
