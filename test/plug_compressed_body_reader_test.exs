defmodule PlugCompressedBodyReaderTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest PlugCompressedBodyReader

  test "returns body as is if there is no content-encoding" do
    body = :crypto.strong_rand_bytes(100)
    conn = conn(:post, "/", body)
    assert {:ok, ^body, _} = PlugCompressedBodyReader.read_body(conn, [])
  end

  test "handle gzip content-encoding content-encoding" do
    body = :crypto.strong_rand_bytes(100)
    compressed = :zlib.gzip(body)

    for encoding <- ["gzip", "x-gzip"] do
      conn =
        conn(:post, "/", compressed) |> Plug.Conn.put_req_header("content-encoding", encoding)

      assert {:ok, ^body, _} = PlugCompressedBodyReader.read_body(conn, [])
    end
  end

  test "returns error if unsupported encoding sent" do
    body = :crypto.strong_rand_bytes(100)
    conn = conn(:post, "/", body) |> Plug.Conn.put_req_header("content-encoding", "UNSUPPORTED")
    assert {:error, "unsupported encoding"} = PlugCompressedBodyReader.read_body(conn, [])
  end
end
