size = 100_000
raw = :crypto.strong_rand_bytes(size)
input = :zlib.gzip(raw)

Benchee.run(%{
  "safe" => fn -> {:ok, ^raw} = PlugCompressedBodyReader.Gzip.decompress(input, [max_chunks: 50]) end,
  "unsafe" => fn -> ^raw = :zlib.gunzip(input) end
}, parallel: System.schedulers_online(), time: 10)
