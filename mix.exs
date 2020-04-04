defmodule StnAccount.MixProject do
  use Mix.Project

  def project do
    [
      app: :stn_account,
      version: "0.1.0",
      elixir: "~> 1.9",
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
      {:ex_doc, "~> 0.21"},
      {:uuid, "~> 1.1"},
      {:money, "~> 1.7"}
    ]
  end
end
