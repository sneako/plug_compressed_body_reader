defmodule PlugCompressedBodyReader.GzipTest do
  use ExUnit.Case, async: true
  alias PlugCompressedBodyReader.Gzip

  test "basic example" do
    bytes = String.duplicate(:crypto.strong_rand_bytes(200), 50)
    compressed = :zlib.gzip(bytes)
    assert {:ok, ^bytes} = Gzip.decompress(compressed)
  end

  test "returns error when it encounters a bomb" do
    bomb_path = Application.app_dir(:plug_compressed_body_reader, ["priv", "bomb", "10GB.gz"])
    bomb = File.read!(bomb_path)
    assert {:error, "max chunks reached"} = Gzip.decompress(bomb)
  end

  test "returns error when data is not gzipped" do
    bytes = :crypto.strong_rand_bytes(100)
    assert {:error, "Erlang error: :data_error"} = Gzip.decompress(bytes)
  end
end
