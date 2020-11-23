defmodule PlugCompressedBodyReader.MixProject do
  use Mix.Project

  @name "PlugCompressedBodyReader"
  @version "0.1.0"
  @repo_url "https://github.com/sneako/plug_compressed_body_reader"

  def project do
    [
      app: :plug_compressed_body_reader,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      name: @name,
      source_url: @repo_url,
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.0"},
      {:benchee, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false}
    ]
  end

  def package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @repo_url}
    ]
  end

  def docs do
    [
      source_ref: "v#{@version}",
      source_url: @repo_url,
      main: @name
    ]
  end
end
