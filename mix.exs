defmodule StnAccount.MixProject do
  use Mix.Project

  def project do
    [
      app: :stn_account,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
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
      {:ex_doc, "~> 0.21", only: [:dev, :test]},
      {:uuid, "~> 1.1"},
      {:money, "~> 1.7"},
      {:excoveralls, "~> 0.12.3", only: [:dev, :test]}
    ]
  end
end
