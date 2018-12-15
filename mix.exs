defmodule Omni.MixProject do
  use Mix.Project

  def project do
    [
      app: :omni,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      {:mnemonic, git: "https://github.com/imerkle/mnemonic.git"},
      {:bip32, git: "https://github.com/imerkle/bip32.git"},
      {:base58check, git: "https://github.com/imerkle/base58check.git"},
      {:keccakf1600, "~> 2.0.0", hex: :keccakf1600_orig},
    ]
  end
end
