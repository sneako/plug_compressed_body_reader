defmodule PlugCompressedBodyReader do
  @external_resource "README.md"
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.fetch!(1)

  alias PlugCompressedBodyReader.Gzip

  @type body :: binary()

  @spec read_body(Plug.Conn.t(), Keyword.t(), Keyword.t()) ::
          {:ok, body(), Plug.Conn.t()} | {:error, String.t()}
  def read_body(conn, plug_opts, opts \\ []) do
    with {:ok, body, conn} <- Plug.Conn.read_body(conn, plug_opts) do
      decompress(conn, body, opts)
    end
  end

  defp decompress(conn, body, opts) do
    with [encoding | _] <- Plug.Conn.get_req_header(conn, "content-encoding"),
         {:ok, decompressed} <- do_decompress(encoding, body, opts) do
      {:ok, decompressed, conn}
    else
      [] ->
        {:ok, body, conn}

      {:error, _} = error ->
        error
    end
  end

  defp do_decompress(encoding, body, opts) when encoding in ["gzip", "x-gzip"] do
    Gzip.decompress(body, opts)
  end

  defp do_decompress(_, _, _) do
    {:error, "unsupported encoding"}
  end
end
