defmodule Excellent.Mixfile do
  use Mix.Project

  def project do
    [app: :excellent,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: Coverex.Task, coveralls: true],
     description: description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:exfswatch, :logger]]
  end

  defp deps do
    [
      { :espec, "~> 0.8.1", only: :test },
      { :coverex, "~> 1.4.3", only: :test },
      { :exfswatch, "~> 0.1.0", only: :test },
    ]
  end

  defp description do
    """
    A OpenXL (Excel files ending with .xlsx) parser for Elixir.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      contributors: ["Leif Gensert"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/leifg/excellent"}
    ]
  end
end
