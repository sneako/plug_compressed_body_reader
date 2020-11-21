# PlugCompressedBodyReader

[Published documentation](https://hexdocs.pm/plug_compressed_body_reader).

<!-- MDOC !-->
Safely decompress HTTP request bodies.

Accepting compressed request bodies on the open internet and decompressing them can be dangerous.
Bad actors can send seemingly small payloads which decompress to an unexpectedly large size.
These payloads are meant to exhaust your server's resources and cause a denial of service for your
intended users.

You can read more about these payloads and find some examples [here](https://bomb.codes/).

Currently only supports GZIP.
<!-- MDOC !-->

## Installation

The package can be installed by adding `plug_compressed_body_reader` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:plug_compressed_body_reader, "~> 0.1.0"}
  ]
end
```

